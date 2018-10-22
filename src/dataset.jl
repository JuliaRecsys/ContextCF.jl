struct DatasetContext{T <: Number}
	contextRatings::ContextRating{T}
    preference::Persa.Preference{T}
    users::Int
    items::Int
	metaContext::Dict
end

## recebe o dataframe junto das variaveis de contexto
DatasetContext(df::DataFrame, metaContextData::Dict) = DatasetContext(df, maximum(df[:user]), maximum(df[:item]),metaContextData)

function DatasetContext(df::DataFrame, users::Int, items::Int, metaContextData::Dict):: DatasetContext
    @assert in(:user, names(df))
    @assert in(:item, names(df))
    @assert in(:rating, names(df))

	contextSet = Dict();

	for (colname,col) in eachcol(df)
		if colname != :user && colname != :item && colname != :rating
			push!(contextSet,colname => col)
		end
	end

    if users < maximum(df[:user]) || items < maximum(df[:item])
        throw(ArgumentError("users or items must satisfy maximum[df[:k]] >= k"))
    end

    preference = Persa.Preference(df[:rating])

	ratings = Persa.convert(df[:rating], preference)

    matriz = Persa.sparse(df[:user], df[:item], ratings, users, items)

	contextRatings = ContextRating(matriz)

	return DatasetContext(contextRatings,preference,users,items,metaContextData)
end
