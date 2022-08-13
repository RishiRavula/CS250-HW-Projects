import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;


public class cachesim {
    static Config cfg;
    static RAM ram;

    static long currentAge;

    public static class Config {
        public Scanner readFile;
        public int cacheSize;
        public int ways;
        public boolean writeThrough;
        public int blockSize;

        public int numBlocks;
        public int sets;

        public int indexBits;
        public int offsetBits;

        public Config(String filePath, int cacheSize, int ways, boolean writeThrough, int blockSize) {
            try {
                this.readFile = new Scanner(new File(filePath));
            } catch (FileNotFoundException e) {
                System.out.println("Failed to open file");
            }

            // this.readFile.useDelimiter(System.getProperty("line.separator"));

            this.cacheSize = cacheSize;
            this.ways = ways;
            this.writeThrough = writeThrough;
            this.blockSize = blockSize;

            this.numBlocks = cacheSize / blockSize;
            this.sets = numBlocks / ways;

            this.indexBits = (int) (Math.log(sets) / Math.log(2));
            this.offsetBits = (int) (Math.log(blockSize) / Math.log(2));

        }
    }

    public static class Instruction {
        public boolean store;
        public int address;
        public int accessSize;
        public char[] data;

        public Instruction(String str) {
            String[] parts = str.split(" ");
            if (parts[0].equals("store")) {
                this.store = true;
                this.address = Integer.parseInt(parts[1], 16);
                this.accessSize = Integer.parseInt(parts[2]);
                this.data = parts[3].toCharArray();
            } else {
                this.store = false;
                this.address = Integer.parseInt(parts[1], 16);
                this.accessSize = Integer.parseInt(parts[2]);
            }
        }

        public static List<Instruction> parseFile() {
            ArrayList<Instruction> result = new ArrayList<>();
            while (cfg.readFile.hasNextLine()) {
                String line = cfg.readFile.nextLine();
                line.replaceAll("\\r\\n", "");
                result.add(new Instruction(line));
            }
            return result;
        }

        @Override
        public String toString() {
            return "Instruction [" + (this.store? "store" : "load") + " " +
            "accessSize=" + accessSize + ", address=" + address + ", data=" + Arrays.toString(data)
                    + "]";
        }
    }

    public static class Block {
        public int address;
        public char[] data = new char[cfg.blockSize * 2];
        public boolean dirty = false;
        public boolean valid = false;
        public long age;

        public Block(int address, long age) {
            this.address = address;
            this.age = age;
        }

        public int getTag(){
            return address >> (cfg.indexBits + cfg.offsetBits);
        }
    }

    public static class RAM {
        Block[] memory;

        public RAM() {
            // memory = new char[2 * 64 * 1024];
            int memSize = (64 * 1024) / cfg.blockSize;
            memory = new Block[memSize];

            for (int i = 0; i < memSize; i++) {
                memory[i] = new Block(i * cfg.blockSize, -1);
                // instantiate memory array with 0s
                for (int j = 0; j < cfg.blockSize * 2; j++) {
                    memory[i].data[j] = '0';
                }
                //memory[i].data = "0".repeat(2 * cfg.blockSize).toCharArray();
            }
        }
    }

    public static class Cache {
        Block[][] cache;

        public Cache() {
            cache = new Block[cfg.sets][cfg.ways];
        }

        public CacheLocation fromMemoryToCache(int address) {
            CacheLocation loc = inCache(address);
            if (loc.hit) {
                return loc;
            }

            Block ramBlock = ram.memory[address / cfg.blockSize];

            boolean evict = true;
            int emptyWay = -1;
            for (int way = 0; way < cfg.ways; way++) {
                if (cache[loc.index][way] == null || cache[loc.index][way].valid == false) {
                    // Found an empty spot
                    evict = false;
                    emptyWay = way;
                    break;
                }
            }

            if (evict) {
                // Evict block, find minimum age block in age
                long testAge = Long.MAX_VALUE;
                int evictWay = 0;
                for (int way = 0; way < cfg.ways; way++) {
                    if (cache[loc.index][way].age < testAge) {
                        testAge = cache[loc.index][way].age;
                        evictWay = way;
                    }
                }

                // Check Dirty Block
                if (cache[loc.index][evictWay].dirty){
                    ram.memory[cache[loc.index][evictWay].address / cfg.blockSize].data = cache[loc.index][evictWay].data.clone();
                }

                emptyWay = evictWay;
            }

            Block newBlock = new Block(ramBlock.address, currentAge);
            newBlock.valid = true;
            newBlock.dirty = false;
            newBlock.data = ramBlock.data.clone();
            cache[loc.index][emptyWay] = newBlock;

            return new CacheLocation(newBlock, loc.index, emptyWay, loc.hit);
        }

        public CacheLocation inCache(int address) {
            int index = (address / cfg.blockSize) % cfg.sets;
            int tag = address / (cfg.sets * cfg.blockSize);

            for (int way = 0; way < cfg.ways; way++) {
                if (cache[index][way] != null && cache[index][way].valid && cache[index][way].getTag() == tag) {
                    cache[index][way].age = currentAge;
                    return new CacheLocation(cache[index][way], index, way, true);
                }
            }
            return new CacheLocation(null, index, -1, false);
        }

        private int align(int address) {
            // Return the starting address of the block containing address
            return address - (address % cfg.blockSize);
        }

        public void store(int address, int size, char[] data) {
            CacheLocation loc = inCache(address);
            int offset = address % cfg.blockSize;
            if (loc.hit) {
                if (cfg.writeThrough) {
                    //Write-Through
                    
                    for (int i = 0; i < size*2; i++) {
                        cache[loc.index][loc.way].data[offset*2 + i] = data[i];
                        ram.memory[address / cfg.blockSize].data[offset*2 + i] = data[i];
                    }
                } else {
                    // Write-back
                    for (int i = 0; i < size*2; i++) {
                        cache[loc.index][loc.way].data[offset*2 + i] = data[i];
                    }
                    cache[loc.index][loc.way].dirty = true;

                }
            } else {
                // Store miss
                if (cfg.writeThrough) {
                    for (int i = 0; i < size*2; i++) {
                        ram.memory[address / cfg.blockSize].data[offset*2 + i] = data[i];
                    }

                } else {
                    // Write-back
                    CacheLocation newLoc = fromMemoryToCache(address);
                    for (int i = 0; i < size*2; i++) {
                        cache[newLoc.index][newLoc.way].data[offset*2 + i] = data[i];
                        // ram.memory[address / cfg.blockSize].data[offset*2 + i] = data[i];
                    }
                    cache[newLoc.index][newLoc.way].dirty = true;
                    // ram.memory[address / cfg.blockSize].data = cache[newLoc.index][newLoc.way].data.clone();
                }

            }

            System.out.printf(
                "store %04x %s\n",
                address,
                loc.hit ? "hit" : "miss"
            );
        }

        /**
         * @param address
         * @param size how many bytes of data to read
         */
        public char[] load(int address, int size) {
            CacheLocation loc = fromMemoryToCache(align(address));

            char[] result  = new char[size * 2];
            int offset = address % cfg.blockSize;

            for (int i = 0; i < size * 2; i++) {
                result[i] = loc.block.data[offset * 2 + i];
            }

            String value = String.valueOf(result);

            System.out.printf(
                "load %04x %s %s\n",
                address,
                loc.hit ? "hit" : "miss",
                value
            );

            return result;

        }

        public void execute(Instruction insn) {
            if (insn.store) {
                this.store(insn.address, insn.accessSize, insn.data);
            } else {
                this.load(insn.address, insn.accessSize);
            }
        }
    }

    public static class CacheLocation {
        public Block block;
        public int index;
        public int way;
        public boolean hit;

        public CacheLocation(Block block, int index, int way, boolean hit) {
            this.block = block;
            this.index = index;
            this.way = way;
            this.hit = hit;
        }
    }

    public static void main(String[] args) {
        // System.out.println("Starting cachesim");

        cfg = new Config(
            args[0],
            Integer.parseInt(args[1])*1024,
            Integer.parseInt(args[2]),
            args[3].equals("wt"),
            Integer.parseInt(args[4])
        );

        ram = new RAM();

        Cache cache = new Cache();

        currentAge = 0;

        List<Instruction> insns = Instruction.parseFile();

        for (int i = 0; i < insns.size(); i++) {
            Instruction instruction = insns.get(i);
            // System.out.println(instruction.toString());
            currentAge++;
            cache.execute(instruction);
        }
    }
}