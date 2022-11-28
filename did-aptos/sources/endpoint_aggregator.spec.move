spec my_addr::endpoint_aggregator {
    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;
    }

    spec create_endpoint_aggregator {
        pragma aborts_if_is_partial;
        let addr = signer::address_of(acct);
        aborts_if exists<EndpointAggregator>(addr);
    }

    spec add_endpoint {
        let addr = signer::address_of(acct);
        let pre_endpoint_aggr = global<EndpointAggregator>(addr);
        aborts_if !exists<EndpointAggregator>(addr);
        aborts_if std::table::spec_contains(pre_endpoint_aggr.endpoints_map,name) == true;
        let post endpoint_aggr = global<EndpointAggregator>(addr);
        ensures contains(endpoint_aggr.names,name);
        ensures std::table::spec_contains(endpoint_aggr.endpoints_map,name) == true;
        // let endpoint_info1 = std::table::spec_get<String, Endpoint>(endpoint_aggr.endpoints_map,name);
    }

    spec batch_add_endpoint {
        pragma aborts_if_is_partial;
        aborts_if len(names) != len(endpoints);
        // let pre_endpoint_aggr = global<EndpointAggregator>(signer::address_of(acct));
        // let post endpoint_aggr = global<EndpointAggregator>(signer::address_of(acct));
        // ensures len(endpoint_aggr.names) == len(pre_endpoint_aggr.names) + len(names);
    }

    spec update_endpoint {
        let addr = signer::address_of(acct);
        aborts_if !exists<EndpointAggregator>(addr);
        let endpoint_aggr = global<EndpointAggregator>(addr);
        aborts_if !std::table::spec_contains(endpoint_aggr.endpoints_map,name);
        // let post endpoint_aggr_post = global<EndpointAggregator>(addr);
    }

    spec delete_endpoint {
        let addr = signer::address_of(acct);
        aborts_if !exists<EndpointAggregator>(addr);
        aborts_if !std::table::spec_contains(pre_endpoint_aggr.endpoints_map,name);
        let pre_endpoint_aggr = global<EndpointAggregator>(addr);
        let post endpoint_aggr = global<EndpointAggregator>(addr);
        ensures std::table::spec_contains(endpoint_aggr.endpoints_map,name) == false;
        // ensures len(endpoint_aggr.names) == len(pre_endpoint_aggr.names) - 1;
    }
}
