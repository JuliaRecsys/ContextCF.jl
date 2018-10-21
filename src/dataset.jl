const defdir = joinpath(dirname(@__FILE__), "..", "datasets")
using DataFrames

struct ContextDataset{T <: Number}
	contextRatings::ContextRating{T}
    ratings::SparseMatrixCSC{AbstractRating{T}, Int}
    preference::Persa.Preference{T}
	metaContext::Dict()
    users::Int
    items::Int
end


DatasetContext(df::DataFrame) = DatasetContext(df, maximum(df[:user]), maximum(df[:item]))


function DatasetContext(df::DataFrame, users::Int, items::Int):: Persa.Dataset
    @assert in(:user, names(df))
    @assert in(:item, names(df))
    @assert in(:rating, names(df))

	contextSet = Dict();

	for (colname,col) in eachcol(df)
		if colname != :user && colname != :item && colname != :rating
			push!(contextSet,colname => col)
		end
	end

	##print(users,items)
	prepareContext(contextSet)

    if users < maximum(df[:user]) || items < maximum(df[:item])
        throw(ArgumentError("users or items must satisfy maximum[df[:k]] >= k"))
    end

    preference = Persa.Preference(df[:rating])

    ratings = Persa.convert(df[:rating], preference)

	## ratings = convert(prepareContext(contextSet),preference)

    matriz = Persa.sparse(df[:user], df[:item], ratings, users, items)

    return Persa.Dataset(matriz, preference, users, items)

	# return DatasetContext(matriz,preference,users,items,contextData)
end

function prepareContext(df::Dict)
	print(keys(df))
end
