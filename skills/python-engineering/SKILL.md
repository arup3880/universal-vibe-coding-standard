---
name: python-engineering
description: >
  Authoritative guide and standards for modern Python (Python 3.12/3.13): PEP 695 type parameter
  syntax, structural pattern matching, modern typing (Self, override, Protocol), project
  management and dependency locking with uv, linting/formatting with ruff, testing with pytest,
  structured concurrency with asyncio.TaskGroup and timeouts, data modeling with Pydantic v2
  and slotted dataclasses, Clean Architecture, and scientific/numerical computing (NumPy
  vectorization, SciPy numerical integration, SymPy symbolic math, Matplotlib). Use whenever
  writing, reviewing, refactoring, testing, or executing Python code.
---

# Modern Python Engineering Standards & Guide

This skill establishes production-grade standards for modern Python (3.12+ and 3.13), emphasizing type safety, lightning-fast tooling (`uv`, `ruff`), structured concurrency, clean data modeling, and high-performance scientific/numerical workflows.

---

## 1. Modern Python Syntax & Language Features (Python 3.12+)

### 1.1 PEP 695 Type Parameter Syntax
Replace verbose `TypeVar`, `Generic`, and `TypeAlias` with the native `type` statement and inline type parameters:

```python
from collections.abc import Sequence, Callable

# Native type aliases
type Point2D = tuple[float, float]
type Matrix[T] = list[list[T]]
type Predicate[T] = Callable[[T], bool]

# Generic functions with inline type parameters
def first_or_default[T](items: Sequence[T], default: T) -> T:
    return items[0] if items else default

# Generic classes
class KeyValueStore[K: str, V]:
    def __init__(self) -> None:
        self._data: dict[K, V] = {}

    def get(self, key: K, default: V) -> V:
        return self._data.get(key, default)
```

### 1.2 Structural Pattern Matching (`match` / `case`)
Use pattern matching with class patterns, sequence patterns, and guard clauses instead of nested `if/elif/isinstance` ladders:

```python
from dataclasses import dataclass

@dataclass(slots=True, frozen=True)
class MoveCommand:
    dx: float
    dy: float

@dataclass(slots=True, frozen=True)
class RotateCommand:
    angle_deg: float

type Command = MoveCommand | RotateCommand | str

def execute(cmd: Command) -> None:
    match cmd:
        case MoveCommand(dx=0.0, dy=0.0):
            pass  # no-op
        case MoveCommand(dx=x, dy=y) if abs(x) > 100 or abs(y) > 100:
            raise ValueError("Displacement exceeds safety limits")
        case MoveCommand(dx=x, dy=y):
            apply_translation(x, y)
        case RotateCommand(angle_deg=deg):
            apply_rotation(deg)
        case "STOP" | "ABORT":
            emergency_brake()
        case _:
            raise TypeError(f"Unknown command format: {cmd!r}")
```

### 1.3 Modern Type Hints & Static Analysis
- **`typing.Self`**: For fluent interfaces and class method returns.
- **`typing.override`**: Annotate overridden methods so the linter flags broken base signatures.
- **`typing.Protocol`**: Define structural typing (duck typing) instead of tight inheritance couplings.

```python
from typing import Self, override, Protocol

class Measurable(Protocol):
    def measure(self) -> float: ...

class BaseSensor:
    def calibrate(self) -> Self:
        # returns the exact concrete subclass instance
        return self

    def read_raw(self) -> float:
        return 0.0

class OpticalPyrometer(BaseSensor):
    @override
    def read_raw(self) -> float:
        return 923.15
```

---

## 2. Modern Project Tooling & Environment Management

### 2.1 The `uv` Workflow
Always prefer `uv` over legacy `pip` / `virtualenv` for 10x-100x faster package installation and deterministic lockfiles:
- **Initialize project**: `uv init my_project && cd my_project`
- **Add dependencies**: `uv add numpy scipy pydantic`
- **Add dev dependencies**: `uv add --dev pytest ruff mypy`
- **Run script in environment**: `uv run python main.py`
- **Run tests**: `uv run pytest`

#### Single-File Scripts with PEP 723 Metadata
Embed dependencies directly inside standalone scripts so they run portably with `uv run`:

```python
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "numpy>=1.26.0",
#     "scipy>=1.12.0",
#     "matplotlib>=3.8.0",
# ]
# ///

import numpy as np
import scipy.integrate as integrate

print(f"NumPy version: {np.__version__}")
```

### 2.2 Formatting & Linting with `ruff`
Configure `pyproject.toml` to unify formatting, imports, and linting rules:

```toml
[tool.ruff]
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "B",   # flake8-bugbear
    "UP",  # pyupgrade (enforces modern python idioms)
    "RUF", # ruff-specific rules
]
ignore = ["E501"] # line length handled by formatter

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

Run checks:
`uv run ruff check --fix . && uv run ruff format .`

---

## 3. Data Modeling & Validation

### 3.1 Pydantic v2 for External Data / APIs
Use Pydantic v2 for I/O validation, config files, and JSON boundaries:

```python
from pydantic import BaseModel, Field, model_validator
from typing import Self

class EngineConfig(BaseModel):
    engine_id: str = Field(min_length=3, max_length=50)
    bore_mm: float = Field(gt=0, description="Piston bore in mm")
    stroke_mm: float = Field(gt=0, description="Piston stroke in mm")
    max_rpm: int = Field(default=3000, le=10000)

    @property
    def swept_volume_cc(self) -> float:
        import math
        return (math.pi / 4.0) * (self.bore_mm ** 2) * self.stroke_mm / 1000.0

    @model_validator(mode="after")
    def validate_aspect_ratio(self) -> Self:
        ratio = self.bore_mm / self.stroke_mm
        if ratio < 0.5 or ratio > 3.0:
            raise ValueError(f"Bore/stroke ratio {ratio:.2f} is outside feasible mechanical limits [0.5, 3.0]")
        return self
```

### 3.2 High-Performance Slotted Dataclasses
For internal domain objects and high-frequency numerical loops, use slotted frozen dataclasses for minimal memory footprint and instant attribute access:

```python
from dataclasses import dataclass

@dataclass(slots=True, kw_only=True, frozen=True)
class RayIntersection:
    zone_index: int
    radial_position_mm: float
    facet_angle_deg: float
    focal_distance_mm: float
    transmission_ratio: float
```

---

## 4. Structured Concurrency & Asynchronous Programming

### 4.1 `asyncio.TaskGroup` (Python 3.11+)
Never use `asyncio.gather()` when handling errors. Use `asyncio.TaskGroup`, which guarantees that if one task fails, all remaining sibling tasks are properly cancelled and child exceptions are bundled into an `ExceptionGroup`:

```python
import asyncio
from collections.abc import Sequence

async def fetch_telemetry(sensor_id: str) -> dict:
    async with asyncio.timeout(3.0):  # clean timeout
        # simulate non-blocking I/O
        await asyncio.sleep(0.1)
        return {"id": sensor_id, "reading": 42.0}

async def read_all_sensors(sensor_ids: Sequence[str]) -> list[dict]:
    results: list[dict] = []
    async with asyncio.TaskGroup() as tg:
        tasks = [tg.create_task(fetch_telemetry(sid)) for sid in sensor_ids]

    # At this point, all tasks have completed successfully
    return [task.result() for task in tasks]
```

### 4.2 Non-Blocking CPU Delegation
Offload heavy CPU computations (ray tracing, ODE solving) to thread/process pools without stalling the async event loop:

```python
async def compute_heavy_optical_grid(params: dict) -> list[float]:
    # Runs in default ThreadPoolExecutor without blocking event loop
    return await asyncio.to_thread(sync_heavy_raytrace, params)
```

---

## 5. Scientific & Numerical Computing Best Practices

### 5.1 NumPy Vectorization
Avoid Python `for` loops in numerical arrays. Use array broadcasting, universal functions (ufuncs), and pre-allocated arrays:

```python
import numpy as np

# BAD: Slow Python loop
# angles = [math.atan(r / (n * math.sqrt(r**2 + f**2) - f)) for r in r_list]

# GOOD: Vectorized NumPy array evaluation
r = np.linspace(1.0, 250.0, 1000)  # radial coordinates in mm
f = 600.0                          # focal length in mm
n = 1.491                          # PMMA refractive index

denom = n * np.sqrt(r**2 + f**2) - f
tan_alpha = r / denom
alpha_rad = np.arctan(tan_alpha)
alpha_deg = np.degrees(alpha_rad)
```

### 5.2 Numerical ODE Integration with SciPy
Use `scipy.integrate.solve_ivp` with explicit tolerances for physical system dynamics:

```python
import numpy as np
from scipy.integrate import solve_ivp

def stirling_piston_ode(t: float, y: np.ndarray, m: float, k: float, c: float) -> np.ndarray:
    # State vector: y = [position, velocity]
    x, v = y
    # dy/dt = [velocity, acceleration]
    # m*a + c*v + k*x = F_ext(t)
    f_ext = 50.0 * np.sin(2.0 * np.pi * 20.0 * t)  # 20 Hz periodic pressure force
    dxdt = v
    dvdt = (f_ext - c * v - k * x) / m
    return np.array([dxdt, dvdt])

sol = solve_ivp(
    fun=stirling_piston_ode,
    t_span=(0.0, 1.0),
    y0=[0.0, 0.0],
    args=(1.2, 850.0, 15.0),  # m=1.2 kg, k=850 N/m, c=15 N·s/m
    method="RK45",
    rtol=1e-6,
    atol=1e-8,
)
```

---

## 6. Testing & Quality Assurance

- Use `pytest` with parameterized test cases:
```python
import pytest
from math import isclose

@pytest.mark.parametrize(
    "temp_hot, temp_cold, expected_carnot",
    [
        (650.0, 35.0, 0.666),
        (500.0, 25.0, 0.614),
        (100.0, 20.0, 0.214),
    ],
)
def test_carnot_efficiency(temp_hot: float, temp_cold: float, expected_carnot: float) -> None:
    t_h = temp_hot + 273.15
    t_c = temp_cold + 273.15
    carnot = 1.0 - (t_c / t_h)
    assert isclose(carnot, expected_carnot, abs_tol=1e-3)
```
