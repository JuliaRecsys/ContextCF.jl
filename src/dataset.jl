const defdir = joinpath(dirname(@__FILE__), "..", "datasets")

function Frappe()::Persa.Dataset
	dataFile = "$(defdir)/frappe/frappe.csv"
	metaFile = "$(defdir)/frappe/meta.csv"

	if !isfile(dataFile) && !isfile(metaFile)
		throw(ArgumentError("Dataset not found, get it on https://github.com/irecsys/CARSKit/blob/master/context-aware_data_sets/Mobile_Frappe.zip"))
	end

	data = CSV.read(dataFile, delim = '\t',
	                      header = [:user, :item, :cnt, :daytime, :weekday, :isweekend, :homework, :cost, :weather, :country, :city],
	                      allowmissing = :none)
	meta= CSV.read(metaFile, delim = '\t',
					header= [:item,:package, :category,:downloads,:developer,:icon,:language,:description, :name, :price, :rating, :short_desc],
						  allowmissing= :none)

	final = join(data,meta, on = :item)

	deleterows!(final,1)

	final[:user] = parse.(Int,final[:user])
	final[:item] = parse.(Int,final[:item])
	#final[:rating] = parse.(Int,final[:rating])

	##print(findfirst( x -> x[11] == "unknown", final))

	return DatasetContext(final)
end
