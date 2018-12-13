using Documenter
using ContextCF

makedocs(
    modules = [ContextCF],
    format = :html,
    sitename = "ContextCF.jl",
    authors = "Paulo Xavier, Filipe Braida and contributors.",
    # analytics = "UA-128580038-1",
    pages    = Any[
        "Introduction"   => "index.md",
        "Dataset" => "man/dataset.md"
        "Rating" => "man/rating.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaRecsys/ContextCF.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
    julia  = "1.0",
)
