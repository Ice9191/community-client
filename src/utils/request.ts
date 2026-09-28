// utils/request.ts

// ============ 类型定义 ============

/** 请求选项（扩展自 uni.request 的选项） */
export interface RequestOptions {
	url : string;                       // 接口路径（不含 baseURL）
	method ?: UniApp.RequestOptions['method'];                  // 请求方法
	data ?: any;                       // 请求参数
	header ?: Record<string, string>;  // 自定义请求头
	timeout ?: number;                 // 超时时间（毫秒）
	isLoading ?: boolean;              // 是否显示 loading，默认 true
	isShowError ?: boolean;            // 是否自动显示错误提示，默认 true
}

/** 后端统一返回结构（根据实际接口调整） */
export interface ResponseData<T = any> {
	code : number;       // 0 表示成功
	message : string;
	data : T;
}

// ============ 环境配置 ============

const BASE_URL : string = process.env.NODE_ENV === 'development'
	? 'http://localhost:3000'
	: 'https://prod-api.example.com';

const DEFAULT_TIMEOUT = 10000;
const DEFAULT_HEADER = {
	'Content-Type': 'application/json',
};

// ============ Loading 控制 ============

let loadingCount = 0;
let loadingTimer : ReturnType<typeof setTimeout> | null = null;
let isLoadingShown = false;

const showLoading = () : void => {
	loadingCount++;
	if (loadingCount === 1 && !isLoadingShown) {
		loadingTimer = setTimeout(() => {
			uni.showLoading({ title: '加载中...', mask: true });
			isLoadingShown = true
		}, 200);
	}
};

const hideLoading = () : void => {
	loadingCount--;
	if (loadingCount <= 0) {
		loadingCount = 0;
		if (loadingTimer) {
			clearTimeout(loadingTimer);
			loadingTimer = null;
		}
		if (isLoadingShown) {
			uni.hideLoading();
			isLoadingShown = false
		}
	}
};

// ============ 核心请求函数 ============

export function request<T = any>(options : RequestOptions) : Promise<T> {
	const {
		url,
		method = 'GET',
		data,
		header = {},
		timeout = DEFAULT_TIMEOUT,
		isLoading = true,
		isShowError = true,
	} = options;

	return new Promise((resolve, reject) => {
		if (isLoading) showLoading();

		// 从本地缓存获取 token
		const token : string = uni.getStorageSync('token') || '';

		uni.request({
			url: BASE_URL + url,
			method,
			data,
			timeout,
			header: {
				...DEFAULT_HEADER,
				...header,
				...(token ? { Authorization: `Bearer ${token}` } : {}),
			},
			success: (res) => {
				// HTTP 状态码 2xx
				if (res.statusCode === 200) {
					const response = res.data as ResponseData<T>;
					if (response.code === 0) {
						resolve(response.data);
					} else {
						// 业务错误
						if (isShowError) {
							uni.showToast({ title: response.message || '请求失败', icon: 'none' });
						}
						// 401 未授权处理
						if (response.code === 401) {
							uni.removeStorageSync('token');
							uni.reLaunch({ url: '/pages/login/login' });
						}
						reject(response);
					}
				} else {
					// HTTP 错误
					if (isShowError) {
						uni.showToast({ title: `网络错误 ${res.statusCode}`, icon: 'none' });
					}
					reject(res);
				}
			},
			fail: (err) => {
				if (isShowError) {
					uni.showToast({ title: '网络异常，请检查网络', icon: 'none' });
				}
				reject(err);
			},
			complete: () => {
				if (isLoading) hideLoading();
			},
		});
	});
}

// ============ 便捷方法（保留泛型） ============

export const get = <T = any>(url : string, data ?: any, options ?: Omit<RequestOptions, 'url' | 'method' | 'data'>) : Promise<T> =>
	request<T>({ url, method: 'GET', data, ...options });

export const post = <T = any>(url : string, data ?: any, options ?: Omit<RequestOptions, 'url' | 'method' | 'data'>) : Promise<T> =>
	request<T>({ url, method: 'POST', data, ...options });

export const put = <T = any>(url : string, data ?: any, options ?: Omit<RequestOptions, 'url' | 'method' | 'data'>) : Promise<T> =>
	request<T>({ url, method: 'PUT', data, ...options });

export const del = <T = any>(url : string, data ?: any, options ?: Omit<RequestOptions, 'url' | 'method' | 'data'>) : Promise<T> =>
	request<T>({ url, method: 'DELETE', data, ...options });

export default request;