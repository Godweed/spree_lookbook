var set_taxon_select_from_parent = function(selector, maximumSelectionSize){
    if ($(selector).length > 0) {
        $(selector).select2({
            placeholder: Spree.translations.taxon_placeholder,
            multiple: true,
            maximumSelectionSize: maximumSelectionSize,
            initSelection: function (element, callback) {
                var url = Spree.url(Spree.routes.taxons_search, {
                    ids: element.val().split(','),
                    token: Spree.api_key
                });
                return $.getJSON(url, null, function (data) {
                    return callback(data['taxons']);
                });
            },
            ajax: {
                url: Spree.routes.taxons_search,
                datatype: 'json',
                data: function (term, page) {
                    return {
                        per_page: 50,
                        page: page,
                        without_children: true,
                        q: {
                            name_cont: term
                        },
                        token: Spree.api_key
                    };
                },
                results: function (data, page) {
                    var more = page < data.pages;
                    return {
                        results: data['taxons'],
                        more: more
                    };
                }
            },
            formatResult: function (taxon) {
                return taxon.pretty_name;
            },
            formatSelection: function (taxon) {
                return taxon.pretty_name;
            }
        });
    }
}

$(document).ready(function () {
    set_taxon_select_from_parent('#lookbook_spree_taxon_id', 1);
    set_taxon_select_from_parent('#kit_taxon_ids', false);
});
