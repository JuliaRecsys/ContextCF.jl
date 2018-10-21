struct ContextRating{T <: Number} <: Persa.AbstractRating{T}
	ratings::SparseMatrixCSC{AbstractRating{T}, Int}
	contextSet::Set{T}
	#contextItem::ContextItem
end

struct ContextItem <: Persa.Rating
 	preference::Persa.Preference
    contextVariables::Dict{String, Any}
end


abstract type anotherTest{T <: Number}
end

struct MyOOtherTest{T <: Number} <: anotherTest{T}
	value2:: T
end


vara = test(4)

varb = MyOtherTest(18)

print(varb.value2)
