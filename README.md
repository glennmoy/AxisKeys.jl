# AxisRanges.jl

[![Build Status](https://travis-ci.org/mcabbott/AxisRanges.jl.svg?branch=master)](https://travis-ci.org/mcabbott/AxisRanges.jl)

This package defines a wrapper which, alongside any array, stores an extra "range" for each dimension.
This may be useful to store perhaps actual times of measurements, 
or some strings labeling columns, etc. 
These will be propagated through many operations on arrays.

They can also be used to look up elements: 
While indexing `A[i]` expects an integer `i ∈ axes(A,1)` as usual, 
`A(t)` instead looks up `t ∈ ranges(A,1)`. 

The package aims to work well with [NamedDims.jl](https://github.com/invenia/NamedDims.jl), which attaches names to dimensions. 
(These names are a tuple of symbols, like those of a `NamedTuple`.)
There's a convenience function `wrapdims` which constructs any combination:
```julia
A = wrapdims(rand(10), 10:10:100)    # RangeArray
B = wrapdims(rand(2,3), :row, :col)  # NamedDimsArray
C = wrapdims(rand(2,10), obs=["dog", "cat"], time=range(0, step=0.5, length=10)) # both
```
With both, we can write `C[time=1, obs=2]` to index by number, 
and `C(time=3.5)` to lookup this key in the range. 
This should work for either a `RangeArray{...,NamedDimsArray}` or the reverse.

The ranges themselves may be any `AbstractVector`s, and `A(20.0)` simply looks up 
`i = findfirst(isequal(20.0), ranges(A,1))` before returning `A[i]`.
Instead of a single value you may also give a function, for instance `A(<(35))`
looks up `is = findall(t -> t<35, ranges(A,1))` and returns the vector `A[is]`,
with its range trimmed to match. You may also give one of a few special selectors:
```julia
A(Nearest(12.5))        # the one nearest element
C(time = Between(1,3))  # matrix with all times in this range
C("dog", Index[3])      # mix of range and integer indexing
C(!=("dog"))            # unambigous as range eltypes are unique
```

While no special types are provided for these ranges,
you could use for instance the arrays from [AcceleratedArrays.jl](https://github.com/andyferris/AcceleratedArrays.jl) 
or from [CategoricalArrays.jl](https://github.com/JuliaData/CategoricalArrays.jl) as needed.
When a dimension’s range is a Julia range, then there are some fast overloads
for things like `findall(<=(42), 10:10:100)`. For vectors, `push!(A, 0.72)` should also
figure out how to extend the range with more steps.

<!--
The larger goal is roughly to divide up the functionality of [AxisArrays.jl](https://github.com/JuliaArrays/AxisArrays.jl)
among smaller packages.
-->
* Broadcasting does not work yet, sadly. But surely can be borrowed from [Tokazama](https://github.com/Tokazama/AbstractIndices.jl)?

* It's not as fast as it could be, right now -- see [test/speed.jl](test/speed.jl) for some numbers.

* It tries to support the [Tables.jl](https://github.com/JuliaData/Tables.jl) interface,
for example `DataFrame(Tables.rows(C))` has column names `[:obs, :time, :value]`.

* And finally, there’s no obvious notation for `setkey!(A, value, key)`.
One idea is to make selectors could work backwards, allowing `A[Key(key)] = val`.
Or a macro `@set A(key) = val`.

Links to the zoo of similar packages:

* Anciet, pre-1.0: [AxisArrays](https://github.com/JuliaArrays/AxisArrays.jl), 
  [NamedArrays](https://github.com/davidavdav/NamedArrays.jl).
  Also perhaps [AxisArrayPlots](https://github.com/jw3126/AxisArrayPlots.jl),
  [LabelledArrays](https://github.com/JuliaDiffEq/LabelledArrays.jl).

* New, or in progress: [NamedDims](https://github.com/invenia/NamedDims.jl), 
  [DimensionalData](https://github.com/rafaqz/DimensionalData.jl),
  [AbstractIndices](https://github.com/Tokazama/AbstractIndices.jl),
  [IndexedDims](https://github.com/invenia/IndexedDims.jl).

* Discussion: [AxisArraysFuture](https://github.com/JuliaCollections/AxisArraysFuture/issues/1),
  [AxisArrays#84](https://github.com/JuliaArrays/AxisArrays.jl/issues/84). 
