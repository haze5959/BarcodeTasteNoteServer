class Singleton {
  private static _instance = new Singleton();
  private constructor() {
  }

  static get instance() {
    return this._instance;
  }
}

const singleton = Singleton.instance;

export { singleton };

// reservation_open 규칙
// '1/2/3/4/5'
// 1 - (예약 오픈일) Y: 매년, M: 매월, W: 매주, D: 매일
// 2 - '1'에서 M의 경우에는 Day, '1'에서 W의 경우에는 요일, 그 외에는 안씀
// 3 - 시간
// 4 - (예약 오픈이 몇일 전에 열리는지) M: 매월, W: 매주
// 5 - '4'에 해당하는 날의 숫자

// "매일 (3개월 이후 자리 오픈)" => D///M/3
// "매주 일요일10시" => W/SUN/10//
// "매월 15일 14시" => M/15/14//
