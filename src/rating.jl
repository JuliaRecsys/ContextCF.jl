struct ContextRating{T <: Number} <: Persa.AbstractRating{T}
    value::T
	context::Dict{Symbol,Union{Missing,Any}}
    ContextRating(x::T, preference::Persa.Preference{T}, context::Dict{Symbol,Any}) where T <: Number = new{T}(Persa.correct(x, preference), context)
end


##TODO assinatura :a=>1 args FINALIZAR
function ContextRating(value::Number,contextColumn::Vararg{Pair})
	context = Dict{Symbol,Union{Missing,Any}}()
	println(typeof(context))
	for column in contextColumn
		(key,value) = column
		push!(context, key => value)
	end
	# ContextRating(value,context)
end

Base.isnan(rating::ContextRating{T}) where T <: Number = false
Base.zero(::Type{ContextRating{T}}) where T <: Number = Persa.MissingRating{T}()

value(::Missing) = missing
value(rating::ContextRating) = rating.value

function value(rating::ContextRating,contextColumn::Symbol)
	@assert haskey(rating.context,contextColumn) "The column $contextColumn doesn't exist on the Rating."
	rating.context[contextColumn]
end

function Base.getindex(rating::ContextRating,contextColumn::Symbol)
	@assert haskey(rating.context,contextColumn) "The column $contextColumn doesn't exist on the Rating."
 	rating.context[contextColumn]
end
