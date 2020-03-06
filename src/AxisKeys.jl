module AxisKeys

include("struct.jl")
export KeyedArray, axiskeys

include("axes.jl")

include("names.jl")
export NamedDimsArray, dimnames

include("wrap.jl")
export wrapdims

include("selectors.jl")
export Near, Index, Interval

include("functions.jl")

include("push.jl")

include("broadcast.jl")

include("show.jl")

include("notpiracy.jl")

include("tables.jl") # Tables.jl

include("stack.jl") # LazyStack.jl

end
