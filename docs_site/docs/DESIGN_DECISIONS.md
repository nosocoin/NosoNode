# NosoNode Design Decisions & Lessons Learned

This document analyzes the current implementation's "questionable" solutions to serve as a guide for the next iteration.

## 1. Tight UI Coupling
**Current State**: High dependency on `MasterPaskalForm`. Many core logic functions call UI methods or read/write to UI components directly.
- **Problem**: Impossible to run as a headless service or daemon without a display environment. Hard to unit test.
- **Lesson**: Separate "Engine" from "UI". Use an event-driven or observer pattern for UI updates.

## 2. Text-Based Protocol with Spaces
**Current State**: Commands are space-separated strings.
- **Problem**: Parsing is prone to errors (e.g., address or reference fields containing unexpected characters). Inefficient in terms of bandwidth.
- **Lesson**: Use a structured binary format (e.g., Protocol Buffers) or a robust serialization like JSON/BSON for complex data.

## 3. Global Static State
**Current State**: Extensive use of global arrays (`Conexiones`, `ArrayPoolTXs`) and global critical sections.
- **Problem**: Race conditions are difficult to track. Rigidness in scaling (e.g., hardcoded `MaxConecciones = 99`).
- **Lesson**: Use Dependency Injection and encapsulated objects. Consider using thread-safe collections instead of manual critical sections everywhere.

## 4. Custom Parameter Parsing
**Current State**: `Parameter(text, index)` is used everywhere for data extraction.
- **Problem**: No schema validation. One missed parameter shifts the indices of all subsequent parameters.
- **Lesson**: Define clear data schemas/models and use proper deserializers.

## 5. File-Based Persistence
**Current State**: Block files and data are stored in custom binary/text formats.
- **Problem**: Risk of file corruption. Slower indexing and searching compared to a dedicated database.
- **Lesson**: Use an embedded database (e.g., SQLite or LevelDB) for block indexing and wallet state.
