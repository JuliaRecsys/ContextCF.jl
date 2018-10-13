module Context

using DatasetsCF
using Persa
using CSV
using DataFrames

include("dataset.jl")

DatasetContext(df::DataFrame) = DatasetContext(df, maximum(df[:user]), maximum(df[:item]))

abstract type AbstractContextRating{T}
end

# struct ContextRating{T <: Number} <: AbstractContextRating{T}
# 	value::{T}
# 	contextSet::Set{T}
# end

# struct ContextItem <: AbstractContextRating
#  	preference::Persa.Preference
#     contextVariables::Dict{String, Any}
# end


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


function MovieLens()::Persa.Dataset
	filename = "$(DatasetsCF.defdir)/ml-100k/u.data"

	DatasetsCF.isfile(filename) || DatasetsCF.getmovielensdata(DatasetsCF.defdir)

	file = CSV.read(filename, delim = '	',
	                      header = [:user, :item, :rating, :timestamp],
	                      allowmissing = :none)


	return DatasetContext(file)
end


a= Frappe()

end # module
