struct ContextRating{T <: Number} <: Persa.AbstractRating{T}
	ratings::SparseMatrixCSC{Persa.AbstractRating{T}, Int}
	# contextSet::Set
	# contextItem::ContextItem
end

#
# struct ContextItem <: Persa.Rating
#  	preference::Persa.Preference
#     contextVariables::Dict{String, Any}
# end
