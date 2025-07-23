package com.grin.edgeplatform.repositories;

import com.grin.edgeplatform.entities.node.Node;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface NodeRepository extends JpaRepository<Node, Long> {

//  @Query("SELECT n FROM Node n JOIN n.connections c WHERE c.vpnIpv4 = :vpnIpv4")
//  Optional<Node> findByVpnIpv4(@Param("vpnIpv4") String vpnIpv4);

  Optional<Node> findByConnections_VpnIpv4(String vpnIpv4);
}
