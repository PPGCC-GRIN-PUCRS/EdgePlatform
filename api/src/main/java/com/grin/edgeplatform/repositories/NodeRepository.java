package com.grin.edgeplatform.repositories;

import com.grin.edgeplatform.entities.Node;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NodeRepository extends JpaRepository<Node, Integer> {
}
