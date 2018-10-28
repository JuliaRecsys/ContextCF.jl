struct ContextRating{T <: Number} <: Persa.AbstractRating{T}
    value::T
	context::Dict{Symbol,Any}
    ContextRating(x::T, preference::Persa.Preference{T}, context::Dict{Symbol,Any}) where T <: Number = new{T}(Persa.correct(x, preference), context)
end

Persa.Base.isnan(rating::ContextRating{T}) where T <: Number = false
Persa.Base.isnan(rating::Persa.MissingRating{T}) where T <: Number = true
Base.zero(::Type{ContextRating{T}}) where T <: Number = Persa.MissingRating{T}()

value(rating::ContextRating) = rating.value
value(rating::ContextRating,contextColumn::Symbol) = rating.context[contextColumn]
