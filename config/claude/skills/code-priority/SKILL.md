---
name: code-priority
description: Guide design decisions using the State > Coupling > Complexity > Code priority framework. Use when evaluating tradeoffs, reviewing design choices, deciding between implementations, or when code volume seems to be prioritized over deeper concerns.
---

<purpose>
Apply the code optimization priority framework: sacrifice lower priorities to improve higher ones.
State > Coupling > Complexity > Code.
</purpose>

<rules priority="critical">
  <rule>Priority 1 - State: Minimize mutable state. Stateless code works identically in sequential, parallel, and distributed contexts</rule>
  <rule>Priority 2 - Coupling: Reduce dependencies. Loose coupling enables independent change and testing</rule>
  <rule>Priority 3 - Complexity: Simplify logic. Lower cognitive load, fewer bugs</rule>
  <rule>Priority 4 - Code: Reduce volume. Less to read and maintain</rule>
  <rule>Each level can be sacrificed to improve a higher-priority concern</rule>
</rules>

<patterns>
  <pattern name="decision-framework">
    <description>When evaluating design choices, follow this priority order</description>
    <steps>
      1. Does Option A have less mutable state than Option B?
         Yes -> Prefer Option A (even if more coupled/complex/verbose)
      2. Does Option A have less coupling than Option B?
         Yes -> Prefer Option A (even if more complex/verbose)
      3. Does Option A have less complexity than Option B?
         Yes -> Prefer Option A (even if more verbose)
      4. Prefer the option with less code
    </steps>
  </pattern>

  <pattern name="prefer-stateless">
    <description>Accept more coupling for less state</description>
    <example>
```python
# More state, less coupling
class Processor:
    def __init__(self):
        self.result = None

    def process(self, data):
        self.result = transform(data)

    def get_result(self):
        return self.result

# Less state, more coupling (PREFERRED)
def process(data, transformer):
    return transformer(data)
```
    </example>
  </pattern>

  <pattern name="prefer-less-coupling">
    <description>Accept more code for less coupling</description>
    <example>
```python
# Less code, more coupling
def create_user(data):
    user = User(**data)
    db.save(user)           # Coupled to global db
    email.send_welcome()    # Coupled to global email
    return user

# More code, less coupling (PREFERRED)
def create_user(data, repository, notifier):
    user = User(**data)
    repository.save(user)
    notifier.send_welcome(user)
    return user
```
    </example>
  </pattern>

  <pattern name="prefer-less-complexity">
    <description>Accept more code for less complexity</description>
    <example>
```python
# Less code, more complexity
result = data if condition else (default if not other else fallback)

# More code, less complexity (PREFERRED)
if condition:
    result = data
elif other:
    result = fallback
else:
    result = default
```
    </example>
  </pattern>
</patterns>

<best_practices>
  <practice priority="critical">Is state being introduced where a pure function would work?</practice>
  <practice priority="high">Are global/shared dependencies creating hidden coupling?</practice>
  <practice priority="high">Is clever code sacrificing readability for brevity?</practice>
  <practice priority="medium">Is the author optimizing for code volume over deeper concerns?</practice>
</best_practices>

<anti_patterns>
  <avoid name="Global singletons">
    <description>Maximum coupling + hidden state</description>
    <instead>Dependency injection</instead>
  </avoid>
  <avoid name="Mutable shared state">
    <description>Race conditions, test complexity</description>
    <instead>Immutable data, message passing</instead>
  </avoid>
  <avoid name="Clever one-liners">
    <description>Complexity hidden in density</description>
    <instead>Explicit multi-line logic</instead>
  </avoid>
  <avoid name="Premature DRY">
    <description>Wrong abstraction, coupling</description>
    <instead>Tolerate duplication until pattern is clear</instead>
  </avoid>
</anti_patterns>

<related_skills>
  <skill name="tidying">Structural improvements often reduce coupling</skill>
  <skill name="tdd">Tests reveal hidden state and coupling problems early</skill>
  <skill name="refactoring">Many patterns specifically target state and coupling</skill>
</related_skills>

<reference>Based on: [curun1r's comment on Hacker News](https://news.ycombinator.com/item?id=11042400), attributed to Sandi Metz's design principles</reference>
