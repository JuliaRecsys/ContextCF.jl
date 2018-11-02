struct DatasetContext{T <: Number} <: Persa.AbstractDataset{T}
	ratings::SparseMatrixCSC{Persa.AbstractRating{T}, Int}
    preference::Persa.Preference{T}
    users::Int
    items::Int
	metaContext::Dict{Symbol,Type}
end

function DatasetContext(df::DataFrame)
	context = Dict{Symbol,Type}()

	for (colname, _) in eachcol(df)
		if colname != :user && colname != :item && colname != :rating
			push!(context, colname => eltype(df[colname]))
		end
	end
	DatasetContext(df,context)
end

DatasetContext(df::DataFrame, metaContextData::Dict) = DatasetContext(df, Persa.Dataset(df), metaContextData)

function DatasetContext(df::DataFrame, contextColumn::Vararg{Symbol})
	metaContextData = Dict{Symbol,Type}()
	for context in contextColumn
		@assert in(context, names(df)) "The column $context doesn't exist on the Dataset."
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

	preference = Persa.Preference(collect(df[:rating]))

	ratings = Vector{Union{Missing,ContextRating}}(missing,size(df)[1])

	for i=1:length(ratings)
	    context = Dict{Symbol,Any}()
		foreach(key -> push!(context, key => df[key][i]), keys(metaContextData))
	    ratings[i] = ContextRating(df[:rating][i],preference,context)
	end

	ratings = [v for v in ratings]

	matriz = sparse(df[:user], df[:item], ratings, dataset.users, dataset.items)

	return DatasetContext{eltype(df[:rating])}(matriz, dataset.preference, dataset.users, dataset.items, metaContextData)
end

function Base.getindex(dataset::DatasetContext, user::Int, item::Int, contextColumn::Int)
	if contextColumn > length(dataset.metaContext)
		throw(ArgumentError("This context column doesn't exist."))
	end
##TODO: refatorar e remover collect se necessário
	collect(values(dataset.ratings[user,item].context))[contextColumn];
end

function Base.getindex(dataset::DatasetContext, user::Int, item::Int, contextColumn::Symbol)
	if !haskey(dataset.metaContext,contextColumn)
		throw(ArgumentError("This context column doesn't exist."))
	end

	dataset.ratings[user,item].context[contextColumn]
end

context(dataset::DatasetContext) = keys(dataset.metaContext)

context(rating::ContextRating) = keys(rating.context)

Base.size(dataset::DatasetContext) = (Persa.users(dataset), Persa.items(dataset), length(context(dataset)))

Base.string(x::DatasetContext) = string("""
									Context Aware Collaborative Filtering Dataset
									- # users: $(Persa.users(x))
									- # items: $(Persa.items(x))
									- # ratings: $(Persa.length(x))
									- # contexts: $(length(context(x)))
									- # contextColumns: $([string(key) for key in collect(ContextCF.context(x))])

									Ratings Preference: $(x.preference)
									""")

Base.print(io::IO, x::DatasetContext) = print(io, string(x))
Base.show(io::IO, x::DatasetContext) = print(io, x)
