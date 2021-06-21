Map<String, int> growInt(int v, int t, int growth, int min, int max) {
  const int int64MaxValue = 9223372036854775807;
  const int int64MinValue = -9223372036854775808;

  if (max == 0) {
    min = int64MinValue;
    max = int64MaxValue;
  }

  int currentTS = DateTime.now().millisecondsSinceEpoch;
  if (growth == 0) {
    return {"v": v, "t": currentTS};
  }
  int tmpValue = v;
  tmpValue += (currentTS - t) * growth;

  int currentVT = 0;
  if (max == 0) {
    max = int64MaxValue;
  }

  int newValue;
  int newTime;

  if (growth > 0) {
    newValue = tmpValue.floor();
    newTime = (t + ((newValue - v) / growth)).ceil();
  } else {
    newValue = tmpValue.ceil();
    newTime = (t + ((newValue - v) / growth)).floor();
  }

  if (newValue > max) newValue = max;

  if (newValue < min) newValue = min;

  return {"v": newValue, "t": newTime};
}



//  grow(time) {
//         if (time < this.t) return
//         if (this.config.growth === 0) return {
//             v: this.v,
//             t: time
//         }

//         var tmpValue = this.v
//         tmpValue += (time-this.t)*this.config.growth
        
//         var newValue = 0
//         var newTime = 0
//         if (this.config.growth > 0) {
//             newValue = Math.floor(tmpValue)
//             newTime = Math.ceil(this.t + ((newValue-this.v)/this.config.growth))
//         } else {
//             newValue = Math.ceil(tmpValue)
//             newTime = Math.floor(this.t + ((newValue-this.v)/this.config.growth))
//         }

//         if (newValue > this.config.max)
//             newValue = this.config.max

//         if (newValue < this.config.min)
//             newValue = this.config.min

//         return {
//             v: newValue,
//             t: newTime
//         }
//     }