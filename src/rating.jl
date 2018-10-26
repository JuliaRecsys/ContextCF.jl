struct ContextRating{T <: Number} <: Persa.AbstractRating{T}
    value::T
	context::Dict{Symbol,Any}
    ContextRating(x::T, preference::Persa.Preference{T}, context::Dict{Symbol,Any}) where T <: Number = new{T}(Persa.correct(x, preference), context)
end
