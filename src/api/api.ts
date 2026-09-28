import {
	post,
	get
} from '@/utils/request';
import type {
	LoginFormType,
	LoginResultType,
	MenuResultType,
	NoticeResultType
} from '@/types/types';

export const loginApi = (data : LoginFormType) => {
	return post<LoginResultType>('/api/user/loginByPwd', data)
}

export const getMenuListApi = () => {
	return get<MenuResultType[]>('/api/menu')
}

export const getNoticeListApi = () => {
	return get<NoticeResultType>('/api/notice')
}