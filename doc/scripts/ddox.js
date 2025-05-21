function setupDdox()
{
	$(".tree-view .package").click(toggleTree);
	$(".tree-view .package a").click(dummy);
	//$(".tree-view.collapsed").children("ul").hide();
	$("#symbolSearch").attr("tabindex", "1000");
}

function dummy() { window.location = $(this).attr("href"); }

function toggleTree()
{
	node = $(this).parent();
	node.toggleClass("collapsed");
	if( node.hasClass("collapsed") ){
		node.children("ul").hide();
	} else {
		node.children("ul").show();
	}
	return false;
}

var searchCounter = 0;
var lastSearchString = "";

function performSymbolSearch(maxlen, maxresults)
{
	if (maxlen === 'undefined') maxlen = 26;
	if (maxresults === undefined) maxresults = 40;

	var searchstring = $("#symbolSearch").val().toLowerCase();

	if (searchstring == lastSearchString) return;
	lastSearchString = searchstring;

	var scnt = ++searchCounter;
	$('#symbolSearchResults').hide();
	$('#symbolSearchResults').empty();

	var terms = $.trim(searchstring).split(/\s+/);
	if (terms.length == 0 || (terms.length == 1 && terms[0].length < 2)) return;

	var results = [];
	for (i in symbols) {
		var sym = symbols[i];
		var all_match = true;
		for (j in terms)
			if (sym.name.toLowerCase().indexOf(terms[j]) < 0) {
				all_match = false;
				break;
			}
		if (!all_match) continue;

		results.push(sym);
	}

	function getPrefixIndex(parts)
	{
		for (var i = parts.length-1; i >= 0; i--)
			for (j in terms)
				if (parts[i].length >= terms[j].length && parts[i].substr(0, terms[j].length) == terms[j])
					return parts.length - 1 - i;
		return parts.length;
	}

	function compare(a, b) {
		// prefer non-deprecated matches
		var adep = a.attributes.indexOf("deprecated") >= 0;
		var bdep = b.attributes.indexOf("deprecated") >= 0;
		if (adep != bdep) return adep - bdep;

		// normalize the names
		var aname = a.name.toLowerCase();
		var bname = b.name.toLowerCase();

		var anameparts = aname.split(".");
		var bnameparts = bname.split(".");

		var asname = anameparts[anameparts.length-1];
		var bsname = bnameparts[bnameparts.length-1];

		// prefer exact matches
		var aexact = terms.indexOf(asname) >= 0;
		var bexact = terms.indexOf(bsname) >= 0;
		if (aexact != bexact) return bexact - aexact;

		// prefer prefix matches
		var apidx = getPrefixIndex(anameparts);
		var bpidx = getPrefixIndex(bnameparts);
		if (apidx != bpidx) return apidx - bpidx;

		// prefer elements with less nesting
		if (anameparts.length < bnameparts.length) return -1;
		if (anameparts.length > bnameparts.length) return 1;

		// prefer matches with a shorter name
		if (asname.length < bsname.length) return -1;
		if (asname.length > bsname.length) return 1;

		// sort the rest alphabetically
		if (aname < bname) return -1;
		if (aname > bname) return 1;
		return 0;
	}

	results.sort(compare);

	for (i = 0; i < results.length && i < maxresults; i++) {
			var sym = results[i];

			var el = $(document.createElement("li"));
			el.addClass(sym.kind);
			for (j in sym.attributes)
				el.addClass(sym.attributes[j]);

			var name = sym.name;

			// compute a length limited representation of the full name
			var nameparts = name.split(".");
			var np = nameparts.length-1;
			var shortname = "." + nameparts[np];
			while (np > 0 && nameparts[np-1].length + shortname.length <= maxlen) {
				np--;
				shortname = "." + nameparts[np] + shortname;
			}
			if (np > 0) shortname = ".." + shortname;
			else shortname = shortname.substr(1);

			el.append('<a href="'+symbolSearchRootDir+sym.path+'" title="'+name+'" tabindex="1001">'+shortname+'</a>');
			$('#symbolSearchResults').append(el);
		}

	if (results.length > maxresults) {
		$('#symbolSearchResults').append("<li>&hellip;"+(results.length-100)+" additional results</li>");
	}

	$('#symbolSearchResults').show();
}
