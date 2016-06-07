
import Iterators: PrefetchIterator, PrefetchState, head
import Base: start, next, done

immutable UniqueIterator
    inner::PrefetchIterator
    UniqueIterator(inner::PrefetchIterator) = new(inner)
    UniqueIterator(inner) = new(PrefetchIterator(inner))
end

immutable UniqueState
    inner::PrefetchState    
end

function start(it::UniqueIterator)
    return UniqueState(start(it.inner))
end

function next(it::UniqueIterator, s::UniqueState)
    ins = s.inner
    hd, ins = next(it.inner, ins)
    while hd == head(ins)
        hd, ins = next(it.inner, ins)
    end
    return hd, UniqueState(ins)
end

# TODO: UniqueIterator(Iterators.PrefetchIterator([1,1,4,5,6,7,8,9,10,10]))
# where's 10?

function done(it::UniqueIterator, s::UniqueState)
    return done(it.inner, s.inner)
end


function uniquesorted(it)
    UniqueIterator(it)
end
