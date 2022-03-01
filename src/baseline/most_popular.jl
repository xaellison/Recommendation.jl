export MostPopular

"""

    MostPopular(data::DataAccessor)

Recommend most popular items.
"""
struct MostPopular <: Recommender
    data::DataAccessor
    scores::AbstractVector

    function MostPopular(data::DataAccessor)
        n_items = size(data.R, 2)
        new(data, vector(n_items))
    end
end

isdefined(recommender::MostPopular) = isfilled(recommender.scores)

function fit!(recommender::MostPopular)
    recommender.scores[:] = vec(sum(!iszero, recommender.data.R, dims=1))
end

function predict(recommender::MostPopular, u::Integer, i::Integer)
    validate(recommender)
    recommender.scores[i]
end
