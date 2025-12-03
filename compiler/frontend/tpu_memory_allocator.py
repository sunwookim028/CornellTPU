# tpu_memory.py
# ---------------------------------------------
# Simple linear memory allocator for TPU On Chip Memory.
# Addresses are 13 bit word address ( 0- 8191)).
# ---------------------------------------------

MEMORY_SIZE = 8192   # 13-bit depth

class MemoryAllocator:
    def __init__(self):
        self.next_free_addr = 0
        self.memory_map = {}    # name -> (addr, size)

    def alloc(self, name, words):
        """
        Allocate 'words' contiguous FP32 entries.
        Returns the starting word address (0-8191).
        """
        if (self.next_free_addr + words) > MEMORY_SIZE:
            raise MemoryError(
                f"Out of TPU BRAM: cannot allocate {words} words for {name}"
            )

        addr = self.next_free_addr
        self.next_free_addr += words

        self.memory_map[name] = (addr, words)
        return addr

    def get(self, name):
        """Get the starting address of a previously allocated tensor."""
        return self.memory_map[name][0]

    def size(self, name):
        """Get size (words) of a previously allocated tensor."""
        return self.memory_map[name][1]

    def dump(self):
        """Print the memory map."""
        print("\n==== TPU MEMORY MAP ====\n")
        for name, (addr, size) in self.memory_map.items():
            print(f"{name:<15} : addr={addr:5d}, size={size} words")
        print(f"\nTotal Memory used: {self.next_free_addr} / {MEMORY_SIZE} words\n")

allocator = MemoryAllocator()
