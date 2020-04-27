package com.hisentw.entity;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, String>, JpaSpecificationExecutor<UserEntity> {
	
	@Query(value = "SELECT SUM(COUNT) FROM USER GROUP BY USER_ID ", nativeQuery = true)
	int getTotalLoginCount();
	
}	