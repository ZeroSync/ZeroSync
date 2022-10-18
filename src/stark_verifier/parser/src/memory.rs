#[derive(Copy, Clone)]
enum MemoryEntryType {
    Pointer,
    Value,
}

#[derive(Copy, Clone)]
pub struct MemoryEntry {
    entry_type: MemoryEntryType,
    value: u64,
}

impl MemoryEntry {
    pub fn new_pointer(value: usize) -> MemoryEntry {
        MemoryEntry {
            entry_type: MemoryEntryType::Pointer,
            value: value as u64,
        }
    }

    pub fn new_value(value: u64) -> MemoryEntry {
        MemoryEntry {
            entry_type: MemoryEntryType::Value,
            value,
        }
    }

    pub fn to_hex(&self) -> String {
        format!("{:#X}", self.value)
    }

    pub fn make_absolute(&self, pointers: &Vec<usize>) -> String {
        let pointer = pointers[self.value as usize];
        format!("{}", pointer)
    }
}

type Memory = Vec<MemoryEntry>;

pub struct DynamicMemory<'a, T> {
    memories: &'a mut Vec<Memory>,
    segment: usize,
    pub context: &'a T,
}

impl<'a, T> DynamicMemory<'a, T> {
    pub fn new(memories: &'a mut Vec<Memory>, context: &'a T) -> DynamicMemory<'a, T> {
        memories.push(Vec::<MemoryEntry>::new());
        DynamicMemory {
            memories: memories,
            segment: 0,
            context,
        }
    }

    pub fn serialize(&self) -> Vec<String> {
        // Concatenate all temporary memories and compute absolute pointers
        let mut concatenated = Vec::<MemoryEntry>::new();
        let mut pointers = Vec::new();

        for vector in &mut self.memories.iter() {
            pointers.push(concatenated.len());
            concatenated.extend(vector);
        }

        // Make the relative pointers absolute
        let mut memory = Vec::new();
        for entry in concatenated {
            match entry.entry_type {
                MemoryEntryType::Pointer => {
                    memory.push(entry.make_absolute(&pointers));
                }
                MemoryEntryType::Value => {
                    memory.push(entry.to_hex());
                }
            }
        }

        memory
    }

    fn write_entry(&mut self, entry: MemoryEntry) {
        self.memories.get_mut(self.segment).unwrap().push(entry);
    }

    pub fn write_pointer(&mut self, pointer: usize) {
        self.write_entry(MemoryEntry::new_pointer(pointer))
    }

    pub fn write_value(&mut self, value: u64) {
        self.write_entry(MemoryEntry::new_value(value))
    }

    pub fn write_array<Q: Writeable<T>>(&mut self, array: Vec<Q>) {
        let mut sub_memory = self.alloc();
        for writable in array {
            writable.write_into(&mut sub_memory);
        }
    }

    fn alloc(&mut self) -> DynamicMemory<T> {
        let segment = self.memories.len();
        self.write_pointer(segment);
        self.memories.push(Vec::<MemoryEntry>::new());
        DynamicMemory {
            memories: self.memories,
            segment: segment,
            context: self.context,
        }
    }
}

pub trait Writeable<T> {
    fn write_into(&self, target: &mut DynamicMemory<T>);
}

impl<T> Writeable<T> for u8 {
    fn write_into(&self, target: &mut DynamicMemory<T>) {
        target.write_value(*self as u64)
    }
}

impl<T> Writeable<T> for u32 {
    fn write_into(&self, target: &mut DynamicMemory<T>) {
        target.write_value(*self as u64)
    }
}

impl<T> Writeable<T> for u64 {
    fn write_into(&self, target: &mut DynamicMemory<T>) {
        target.write_value(*self)
    }
}

impl<T> Writeable<T> for usize {
    fn write_into(&self, target: &mut DynamicMemory<T>) {
        target.write_value(*self as u64)
    }
}
