package com.hisentw.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Table(name = "USER")
@Entity
@Getter
@Setter
public class UserEntity implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "USER_ID")
	private String userId;
	
	@Column(name = "USER_NAME")
	private String userName;
	
	@Column(name = "ACCOUNT")
	private String account;
	
	@Column(name = "PASSWORD")
	private String password;
	
	@Column(name = "USER_IMAGE")
	@Lob
	private byte[] userImage;
	
	@Column(name = "COUNT")
	private int count;
	
}
