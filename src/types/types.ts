export interface LoginFormType {
	username : string
	password : string
	agree ?: string
}

export interface UserInfo {
	id : number
	username : string
	nickname ?: string
	avatar ?: string
	phone ?: string
}

export interface LoginResultType {
	token : string
	user : UserInfo
}

export interface MenuResultType {
	id : number
	name : string
	icon : string
	url : string
	bg : string
}

export interface NoticeListType {
	id : number
	title : string
	time : string
	reads : number
	top : 0 | 1
}

export interface NoticeResultType {
	total : number
	list : NoticeListType[]
}