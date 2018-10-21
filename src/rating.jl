# struct ContextRating{T <: Number} <: Persa.AbstractRating{T}
# 	ratings::SparseMatrixCSC{AbstractRating{T}, Int}
# 	contextSet::Set{T}
# 	#contextItem::ContextItem
# end
#
# struct ContextItem <: Persa.Rating
#  	preference::Persa.Preference
#     contextVariables::Dict{String, Any}
# end
