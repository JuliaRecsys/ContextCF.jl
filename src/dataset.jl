struct DatasetContext{T <: Number} <: Persa.AbstractDataset{T}
	ratings::SparseMatrixCSC{ContextRating{T}, Int}
    preference::Persa.Preference{T}
    users::Int
    items::Int
	metaContext::Dict{Symbol,DataType}
end


DatasetContext(df::DataFrame, metaContextData::Dict) = DatasetContext(df, Persa.Dataset(df), metaContextData)

function DatasetContext(df::DataFrame, contextColumn::Vararg{Symbol})
	metaContextData = Dict{Symbol,DataType}()
	for context in contextColumn
		@assert in(context, names(df)) "A coluna $context não existe no Dataset."
		push!(metaContextData, context => eltype(df[context]))
	end

	DatasetContext(df,metaContextData)
end

function DatasetContext(df::DataFrame, dataset::Persa.Dataset, metaContextData::Dict):: DatasetContext
	@assert in(:user, names(df))
	@assert in(:item, names(df))
	@assert in(:rating, names(df))

	if dataset.users < maximum(df[:user]) || dataset.items < maximum(df[:item])
		throw(ArgumentError("users or items must satisfy maximum[df[:k]] >= k"))
	end

	preference = Persa.Preference(df[:rating])

	ratings = Vector{Union{Missing,ContextRating}}(missing,size(df)[1])

	for i=1:length(ratings)
	    context = Dict{Symbol,Any}()
		foreach(key -> push!(context, key => df[key][i]), keys(metaContextData))
	    ratings[i] = ContextRating(df[:rating][i],preference,context)
	end

	ratings = [v for v in ratings]

	matriz = sparse(df[:user], df[:item], ratings, dataset.users, dataset.items)

	return DatasetContext(matriz, dataset.preference, dataset.users, dataset.items, metaContextData)
end

function Base.getindex(dataset::DatasetContext, user::Int, item::Int, contextColumn::Int)
	if contextColumn > length(dataset.metaContext)
		throw(ArgumentError("Essa coluna contexto não existe."))
	end

	collect(values(dataset.ratings[user,item].context))[contextColumn];
end

function Base.getindex(dataset::DatasetContext, user::Int, item::Int, contextColumn::Symbol)
	if !haskey(dataset.metaContext,contextColumn)
		throw(ArgumentError("Essa coluna contexto não existe."))
	end

	dataset.ratings[user,item].context[contextColumn]
end

context(dataset::DatasetContext) = keys(dataset.metaContext)

Base.size(dataset::DatasetContext) = (Persa.users(dataset), Persa.items(dataset), length(context(dataset)))
