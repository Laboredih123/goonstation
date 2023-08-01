//////////////////////
//datum/heap object
//////////////////////

#define HeapPathWeightCompare(a, b) (b:f_value - a:f_value)
/datum/heap
	var/list/L

/datum/heap/New()
	..()
	L = new()

/datum/heap/disposing()
	for(var/i in L) // because this is before the list helpers are loaded
		qdel(i)
	L = null
	..()

/datum/heap/proc/is_empty()
	return !length(L)

/// insert and place at its position a new node in the heap
/datum/heap/proc/insert(atom/A)
	L.Add(A)
	swim(length(L))

/// removes and returns the first element of the heap
/// (i.e the max or the min dependant on the comparison function)
/datum/heap/proc/pop()
	if(!length(L))
		return 0
	. = L[1]

	L[1] = L[length(L)]
	L.Cut(length(L))
	if(length(L))
		sink(1)

/// Get a node up to its right position in the heap
/datum/heap/proc/swim(index)
	var/parent = round(index * 0.5)

	while(parent > 0 && (HeapPathWeightCompare(L[index],L[parent]) > 0))
		L.Swap(index,parent)
		index = parent
		parent = round(index * 0.5)

/// Get a node down to its right position in the heap
/datum/heap/proc/sink(index)
	var/g_child = get_greater_child(index)

	while(g_child > 0 && (HeapPathWeightCompare(L[index],L[g_child]) < 0))
		L.Swap(index,g_child)
		index = g_child
		g_child = get_greater_child(index)

/// Returns the greater (relative to the comparison proc) of a node children
/// or 0 if there's no child
/datum/heap/proc/get_greater_child(index)
	var/doubledindex = index * 2
	var/doubleplusone = doubledindex + 1
	if(doubledindex > length(L))
		return 0

	if(doubleplusone > length(L))
		return doubledindex

	if(HeapPathWeightCompare(L[doubledindex],L[doubleplusone]) < 0)
		return doubleplusone
	else
		return doubledindex

/// Replaces a given node so it verify the heap condition
/datum/heap/proc/resort(atom/A)
	var/index = L.Find(A)

	swim(index)
	sink(index)

/datum/heap/proc/List()
	. = L.Copy()
