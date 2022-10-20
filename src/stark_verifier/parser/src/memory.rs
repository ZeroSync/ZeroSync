pub enum MemoryEntry {
    Value { value: String }, 
    Pointer { pointer : usize }
}

impl MemoryEntry {
    fn to_string(&self, pointers_map: &Vec<usize>) -> String {
        match self {
            MemoryEntry::Value { value } => value.to_string(), 
            MemoryEntry::Pointer { pointer } => 
                format!("{}", pointers_map[ *pointer ] )
        }
    }

    fn from_u64(value: u64) -> MemoryEntry {
        MemoryEntry::Value { value: format!("{:#X}", value) }
    }

    fn from_hex(value: String) -> MemoryEntry {
        MemoryEntry::Value { value }
    }

    fn from_pointer(pointer: usize) -> MemoryEntry {
        MemoryEntry::Pointer { pointer }
    }
}



type Memory = Vec<MemoryEntry>;

pub struct DynamicMemory<'a> {
    memories: &'a mut Vec<Memory>,
    segment: usize,
}

impl<'a> DynamicMemory<'a> {

    pub fn new(memories: &'a mut Vec<Memory>) -> DynamicMemory<'a> {
        memories.push(Vec::<MemoryEntry>::new());
        DynamicMemory {
            memories: memories,
            segment: 0,
        }
    }


    pub fn assemble(&self) -> Vec<String> {
        // Concatenate all memories and compute a mapping for pointers
        let mut concatenated = Vec::<&MemoryEntry>::new();
        let mut pointers_map = Vec::new();

        for vector in self.memories.iter() {
            pointers_map.push(concatenated.len());
            concatenated.extend(vector);
        }

        // Iterate through all memory entries and map the pointers
        let mut memory = Vec::new();
        for entry in concatenated {
            memory.push( entry.to_string(&pointers_map) );
        }

        memory
    }

    fn write_entry(&mut self, entry: MemoryEntry) {
        self.memories.get_mut(self.segment).unwrap().push(entry);
    }

    pub fn write_pointer(&mut self, pointer: usize) {
        self.write_entry(MemoryEntry::from_pointer(pointer))
    }

    pub fn write_value(&mut self, value: u64) {
        self.write_entry(MemoryEntry::from_u64(value))
    }

    pub fn write_hex_value(&mut self, value: String) {
        self.write_entry(MemoryEntry::from_hex(value))
    }

    pub fn write_array<T: Writeable>(&mut self, array: Vec<T>) {
        let mut sub_memory = self.alloc();
        for writable in array {
            writable.write_into(&mut sub_memory);
        }
    }

    pub fn write_array_with<Params, T: WriteableWith<Params>, F>(&mut self, array: Vec<T>, f: F)
    where
        F: Fn(u32) -> Params,
    {
        let mut sub_memory = self.alloc();
        let mut i = 0;
        for writable in array {
            writable.write_into(&mut sub_memory, f(i));
            i += 1;
        }
    }

    fn alloc(&mut self) -> DynamicMemory {
        let segment = self.memories.len();
        self.write_pointer(segment);
        self.memories.push(Vec::<MemoryEntry>::new());
        DynamicMemory {
            memories: self.memories,
            segment: segment,
        }
    }
}

pub trait Writeable {
    fn write_into(&self, target: &mut DynamicMemory);
}

impl Writeable for u8 {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_value(*self as u64)
    }
}

impl Writeable for u32 {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_value(*self as u64)
    }
}

impl Writeable for u64 {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_value(*self)
    }
}

impl Writeable for usize {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_value(*self as u64)
    }
}

pub trait WriteableWith<Parameters> {
    fn write_into(&self, target: &mut DynamicMemory, params: Parameters);
}
