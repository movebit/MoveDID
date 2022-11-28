spec my_addr::addr_aggregator {
    spec module {
        pragma verify = true;
    }

    /// AddrAggregatord does not under the signer befroe creating it.
    /// Make sure the AddrAggregatord exists under the signer after creating it.
    spec create_addr_aggregator(acct: &signer, type: u64, description: String) {
        let addr = signer::address_of(acct);
        aborts_if exists<AddrAggregator>(addr);
        ensures exists<AddrAggregator>(addr);
    }

    spec update_addr_aggregator_description(acct: &signer, description: String) {
        aborts_if !exists<AddrAggregator>(signer::address_of(acct));
    }

    /// The addr is 0x begin.
    /// The AddrAggregatord is under the signer.
    /// Check addr_info is already exist under the addr.
    /// Max id does not exceed MAX_U64.
    spec add_addr{
        include addr_info::CheckAddrPrefix;
        let account = signer::address_of(acct);
        let addr_aggr = global<AddrAggregator>(account);
        let post addr_aggr_post = global<AddrAggregator>(account);
        ensures !spec_exist_addr_by_map(addr_aggr.addr_infos_map, addr);
        ensures spec_exist_addr_by_map(addr_aggr_post.addr_infos_map,addr);
        ensures contains(addr_aggr_post.addrs, addr);
        ensures addr_aggr.max_id + 1 <= MAX_U64;
    }

    spec fun spec_exist_addr_by_map (addr_infos_map: Table<String, AddrInfo>, addr: String): bool {
        table::spec_contains(addr_infos_map, addr)
    }

    /// The number of 'addr' added is the same as the number of 'addrinfo'.
    /// The AddrAggregatord is under the signer.
    spec  batch_add_addr(
        acct: &signer,
        addrs: vector<String>,
        addr_infos : vector<AddrInfo>
    ) {
        let addrs_length = len(addrs);
        let post addr_aggr = global<AddrAggregator>(signer::address_of(acct));
        ensures len(addrs) == len(addr_infos);
    }

    /// check addr is 0x begin.
    /// The AddrAggregatord is under the signer.
    spec update_eth_addr(acct: &signer, addr: String, signature: String) {
        include addr_info::CheckAddrPrefix;
        let addr_aggr = global<AddrAggregator>(signer::address_of(acct));
        let addr_info = table::spec_get(addr_aggr.addr_infos_map, addr);
        include addr_eth::UpdateAddr{addr_info};
    }

    /// The addr is 0x begin.
    /// The AddrAggregatord is under the signer.
    spec update_aptos_addr(acct: &signer, addr: String, signature: String) {
        include addr_info::CheckAddrPrefix;
        let addr_aggr = global<AddrAggregator>(signer::address_of(acct));
        let addr_info = table::spec_get(addr_aggr.addr_infos_map, addr);
        include addr_aptos::UpdateAddr{addr_info};
    }

    /// The addr is 0x begin.
    /// The AddrAggregatord is under the signer.
    spec update_addr_msg_with_chains_and_description(acct: &signer, addr: String, chains: vector<String>, description: String) {
        include addr_info::CheckAddrPrefix;
        let addr_aggr = global<AddrAggregator>(signer::address_of(acct));
        let addr_info = table::spec_get(addr_aggr.addr_infos_map, addr);
        ensures len(addr_info.signature) != 0;
        }

    /// The addr is 0x begin.
    /// The AddrAggregatord is under the signer.
    spec update_addr_for_non_verify(acct: &signer, addr: String, chains: vector<String>, description: String) {
        include addr_info::CheckAddrPrefix;
        let addr_aggr = global<AddrAggregator>(signer::address_of(acct));
        let addr_info = table::spec_get(addr_aggr.addr_infos_map, addr);
        include addr_info::UpdateAddrForNonVerify{addr_info};
        }

    /// The addr is 0x begin.
    /// The AddrAggregatord is under the signer.
    spec delete_addr(acct: &signer, addr: String) {
        include addr_info::CheckAddrPrefix;
        let addr_aggr = global<AddrAggregator>(signer::address_of(acct));
        let length = len(addr_aggr.addrs);
        let post addr_aggr_post = global<AddrAggregator>(signer::address_of(acct));
        ensures !table::spec_contains(addr_aggr_post.addr_infos_map, addr);
    }
}
