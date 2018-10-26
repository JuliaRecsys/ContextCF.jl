struct ContextRating{T <: Number} <: Persa.AbstractRating{T}
    value::T
	context::Dict{Symbol,Any}
    ContextRating(x::T, preference::Persa.Preference{T}, context::Dict{Symbol,Any}) where T <: Number = new{T}(Persa.correct(x, preference), context)
end

function Base.getindex(dataset::ContextCF.DatasetContext, user::Int, item::Int, contextColumn::Int)
	if contextColumn > length(dataset.metaContext)
		throw(ArgumentError("Essa coluna contexto não existe."))
	end

	collect(values(dataset.ratings[user,item].context))[contextColumn];
end

function Base.getindex(dataset::ContextCF.DatasetContext, user::Int, item::Int, contextColumn::Symbol)
	if !haskey(dataset.metaContext,contextColumn)
		throw(ArgumentError("Essa coluna contexto não existe."))
	end

	dataset.ratings[user,item].context[contextColumn]
end
