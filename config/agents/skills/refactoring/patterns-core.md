# Refactoring Core Catalog

Language-agnostic, Fowler-aligned behavior-preserving transformations.

## Composing Functions and Methods

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Extract Function / Method** | Code block does one identifiable thing | Move code to a new function and replace it with a call |
| **Inline Function / Method** | Function body is clearer than its name | Replace call sites with the body and remove the function |
| **Extract Variable** | Expression is complex or repeated | Bind a well-named variable |
| **Inline Variable** | Variable adds no clarity | Replace the variable with its expression |
| **Replace Temp with Query** | Temporary value is easily recomputed | Extract the computation into a query function |
| **Split Variable** | One variable serves multiple purposes | Replace it with one variable per responsibility |
| **Slide Statements** | Related statements are separated | Move related statements together |
| **Split Loop** | One loop does multiple jobs | Use separate loops for separate responsibilities |
| **Replace Loop with Pipeline** | Loop is mostly map/filter/reduce style work | Replace the loop with a pipeline abstraction where appropriate |
| **Substitute Algorithm** | Current algorithm is unclear or overly complex | Swap in a clearer algorithm while preserving behavior |

## Moving Features

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Move Function / Method** | Behavior depends more on another module or type | Move the function and adapt callers |
| **Move Field** | Data belongs with another abstraction | Move the field and update references |
| **Move Statements into Function** | Setup or transformation repeats at call sites | Pull common statements into the callee |
| **Move Statements to Callers** | Shared logic in a callee is no longer shared | Push statements outward to only the callers that need them |
| **Extract Class** | One type has multiple responsibilities | Create a new class or module and move related behavior |
| **Inline Class** | A type no longer earns its existence | Fold its responsibility into another abstraction |
| **Hide Delegate** | Clients reach through one object to another | Add delegating methods at the boundary |
| **Remove Middle Man** | Boundary object only forwards calls | Let callers access the real target directly |
| **Combine Functions into Class** | Several functions share the same data context | Group them into a class or module around that context |
| **Combine Functions into Transform** | Several functions repeatedly derive the same record shape | Build one transformation boundary that computes the derived data |

## Organizing Data

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Replace Magic Literal with Named Constant** | Literal carries domain meaning | Introduce a named constant |
| **Replace Primitive with Object** | Primitive has validation or behavior | Introduce a value object |
| **Encapsulate Variable / Field** | Shared mutable data needs control | Hide direct access behind a boundary |
| **Encapsulate Collection** | Collection should not be mutated directly by clients | Expose intention-revealing operations instead of raw mutation |
| **Encapsulate Record** | Record layout leaks too broadly | Hide record shape behind accessors or methods |
| **Change Value to Reference** | Distinct references should share identity | Replace copies with shared references |
| **Change Reference to Value** | Shared identity is causing coupling | Replace references with immutable or copied values |
| **Replace Type Code with Class** | Simple code identifies a concept | Introduce a dedicated type |
| **Replace Type Code with Subclasses** | Variant affects behavior and is stable | Split behavior across subclasses |
| **Replace Type Code with State / Strategy** | Variant affects behavior and changes over time | Delegate to interchangeable behavior objects |

## Simplifying Conditionals

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Decompose Conditional** | Conditional obscures the domain rule | Extract condition and branches into named functions |
| **Consolidate Conditional Expression** | Multiple checks lead to the same outcome | Merge into one expression |
| **Consolidate Duplicate Conditional Fragments** | Same statements appear in all branches | Move the duplicate outside the conditional |
| **Replace Control Flag with Break / Return** | Flag exists only to control flow | Use direct control flow instead |
| **Replace Nested Conditional with Guard Clauses** | Nesting hides the normal path | Return early for exceptional cases |
| **Replace Conditional with Polymorphism** | Branches depend on stable variant behavior | Move behavior behind polymorphic dispatch |
| **Introduce Special Case / Null Object** | Repeated null or empty handling clutters code | Introduce an explicit special-case object |
| **Introduce Assertion** | Code assumes a condition that should be explicit | Assert the invariant |

## Refactoring APIs

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Change Function Declaration** | Name or parameters no longer fit the abstraction | Change signature in controlled steps |
| **Rename Variable** | Name obscures intent | Rename to reflect meaning |
| **Rename Field** | Field name is misleading | Rename and update all access sites |
| **Separate Query from Modifier** | One function both returns data and mutates state | Split query and command behavior |
| **Parameterize Function / Method** | Similar functions differ only by a value | Merge them into one parameterized function |
| **Remove Flag Argument** | Boolean or enum parameter selects behavior | Split into explicit functions |
| **Preserve Whole Object** | Several parameters come from the same source object | Pass the source object itself |
| **Replace Parameter with Query** | Callee can derive a parameter itself | Move the derivation into the callee |
| **Replace Query with Parameter** | Hidden dependency hurts clarity or testability | Pass the value explicitly |
| **Introduce Parameter Object** | Parameters travel as a conceptual group | Introduce an object that carries them |
| **Remove Setting Method** | State should only be established at creation time | Remove setter-style mutation |
| **Replace Constructor with Factory Function** | Construction needs naming, branching, or shielding | Introduce a factory boundary |
| **Return Modified Value** | Mutation is hidden but result matters to callers | Return the updated value explicitly |

## Error Handling and Phasing

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Replace Error Code with Exception** | Error codes obscure the main flow | Raise structured errors instead |
| **Replace Exception with Precheck** | Exceptional control flow is expected and common | Check preconditions before acting |
| **Split Phase** | One routine mixes parsing, validation, and execution | Separate the phases into distinct steps |
| **Replace Command with Function** | Stateful command object is unnecessary | Replace it with a plain function |
| **Replace Function with Command** | Operation needs richer state or lifecycle | Wrap behavior in a command object |
| **Replace Inline Code with Function Call** | Same statement sequence appears repeatedly | Centralize it behind a named function |
| **Remove Dead Code** | Behavior no longer has reachable users | Delete unused code and references |

## Dealing with Inheritance

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Pull Up Field** | Siblings share the same field | Move it to the superclass |
| **Pull Up Method** | Siblings share identical behavior | Move it to the superclass |
| **Pull Up Constructor Body** | Subclass construction is mostly duplicated | Move the common construction logic upward |
| **Push Down Field** | Shared field is only relevant to some children | Move it to those children |
| **Push Down Method** | Shared method is only relevant to some children | Move it to those children |
| **Extract Subclass** | Rare features only apply to part of a hierarchy | Move them into a subclass |
| **Extract Superclass** | Several types share common behavior | Introduce a shared parent |
| **Extract Interface** | Clients need only a subset of behavior | Expose an interface for that subset |
| **Collapse Hierarchy** | Inheritance split no longer matters | Merge the hierarchy back together |
| **Replace Subclass with Delegate** | Variant behavior can be modeled by composition | Delegate instead of subclassing |
| **Replace Inheritance with Delegation** | Inheritance only partially fits the problem | Replace superclass dependence with delegation |
| **Replace Delegation with Inheritance** | Simple delegation obscures a genuine is-a relationship | Inherit when it simplifies the model |
| **Remove Subclass** | Subclass adds no distinct value | Remove it and fold behavior upward |

## Big Refactorings

Use incrementally, not as a single jump.

| Pattern | When to Use |
|---------|-------------|
| **Tease Apart Inheritance** | One hierarchy is handling multiple axes of variation |
| **Convert Procedural Design to Objects** | Shared mutable data drives long procedures |
| **Separate Domain from Presentation** | UI or delivery concerns are tangled with domain logic |
| **Extract Hierarchy** | One abstraction carries too many behavioral variants |

## Pattern Selection by Smell

| Smell | Patterns to Consider |
|-------|---------------------|
| **Duplicated Code** | Extract Function, Slide Statements, Replace Inline Code with Function Call |
| **Long Function** | Extract Function, Split Loop, Decompose Conditional |
| **Large Class / Module** | Extract Class, Combine Functions into Class, Extract Interface |
| **Long Parameter List** | Introduce Parameter Object, Preserve Whole Object |
| **Divergent Change** | Extract Class, Split Phase |
| **Shotgun Surgery** | Move Function, Move Field, Hide Delegate |
| **Feature Envy** | Move Function, Extract Function |
| **Data Clumps** | Introduce Parameter Object, Combine Functions into Transform |
| **Primitive Obsession** | Replace Primitive with Object, Replace Type Code with Class |
| **Switch Statements** | Replace Conditional with Polymorphism, Introduce Special Case |
| **Lazy Class** | Inline Class, Collapse Hierarchy, Remove Subclass |
| **Speculative Generality** | Collapse Hierarchy, Inline Class, Remove Flag Argument |
| **Message Chains** | Hide Delegate, Move Function |
| **Middle Man** | Remove Middle Man, Inline Function |
| **Comments Explaining the Code** | Extract Function, Rename Variable, Rename Field |
| **Error-Driven Control Flow** | Replace Exception with Precheck, Split Phase |
| **Dead Code** | Remove Dead Code |
