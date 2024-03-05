local judgements = {}

judgements.ratings = { -- percent of minimum
    {40,"Bad"},
    {60,"Okay"},
    {80,"Great"},
    {90,"Perfect"},
    {100,"Marvelous"},
}

function judgements.judge(n)
    for i,v in pairs(judgements.ratings) do
        local requirement, rating = v[1],v[2]
        if n < (requirement)/100 then
            return rating,requirement
        end
    end
end


return judgements