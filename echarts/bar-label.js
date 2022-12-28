
// https://echarts.apache.org/examples/zh/index.html#chart-type-bar

// 格式
// https://echarts.apache.org/examples/zh/editor.html?c=bar-label-rotation
{
  name: 'Forest',
  type: 'bar',
  barGap: 0,
  label: labelOption,
  emphasis: {
    focus: 'series'
  },
  data: [320, 332, 301, 334, 390]
},

// 指定数据到坐标轴的映射
// https://echarts.apache.org/examples/zh/editor.html?c=dataset-encode0

// 系列按行按列分布
// https://echarts.apache.org/examples/zh/editor.html?c=dataset-series-layout-by
// source:
[
  ['product', '2012', '2013', '2014', '2015'],
  ['Matcha Latte', 41.1, 30.4, 65.1, 53.3],
  ['Milk Tea', 86.5, 92.1, 85.7, 83.1],
  ['Cheese Cocoa', 24.1, 67.2, 79.5, 86.4]
];

[
  ['product', 'fmp_apdex', 's1', 's2'],
  ['app_name1', 41.1, 30.4, 65.1],
  ['app_name2', 86.5, 92.1, 85.7],
  ['app_name3', 24.1, 67.2, 79.5]
];


const fmpApdex = {
  'creditweb           ': [ { fmp_apdex: '54.67', s1: '28.61', s2: '52.08' } ],
  'applyweb            ': [ { fmp_apdex: '70.81', s1: '44.01', s2: '86.77' } ],
  'businessweb         ': [ { fmp_apdex: '82.22', s1: '64.93', s2: '95.11' } ],
  'cmscommon           ': [ { fmp_apdex: '75.49', s1: '52.90', s2: '88.28' } ],
  'creditwebmpaash5    ': [ { fmp_apdex: '83.91', s1: '68.96', s2: '92.94' } ],
  'applywebmpaash5     ': [ { fmp_apdex: '98.56', s1: '97.18', s2: '99.78' } ],
  'businesswebmpaash5  ': [ { fmp_apdex: '87.29', s1: '74.75', s2: '98.51' } ],
  'cmscommonmpaash5    ': [ { fmp_apdex: '94.59', s1: '89.68', s2: '98.23' } ],
  'tarowebh5           ': [ { fmp_apdex: '59.13', s1: '20.67', s2: '83.92' } ],
  'loanweb             ': [ { fmp_apdex: '56.33', s1: '15.08', s2: '77.15' } ],
  'huanbeiapp          ': [ { fmp_apdex: '62.39', s1: '27.75', s2: '73.81' } ],
  'cmscommonweb        ': [ { fmp_apdex: '60.06', s1: '23.25', s2: '81.48' } ],
  'miscweb             ': [ { fmp_apdex: '51.31', s1: '9.09', s2: '51.93' } ],
  'memberweb           ': [ { fmp_apdex: '64.32', s1: '31.46', s2: '87.95' } ],
  'hbzc                ': [ { fmp_apdex: '63.27', s1: '30.01', s2: '80.54' } ],
  'hbcampaign          ': [ { fmp_apdex: '59.01', s1: '19.36', s2: '81.60' } ],
  'apphq               ': [ { fmp_apdex: '77.82', s1: '62.51', s2: '81.70' } ],
  'hbmgm               ': [ { fmp_apdex: '50.83', s1: '6.99', s2: '69.05' } ],
  'cmsweb              ': [ { fmp_apdex: '50.03', s1: '2.36', s2: '68.72' } ],
  'hbcoupon            ': [ { fmp_apdex: '71.76', s1: '44.82', s2: '91.46' } ],
  'hbmembership        ': [ { fmp_apdex: '66.13', s1: '35.60', s2: '76.21' } ]
};

const temp2 = [['product', 'fmp_apdex', 's1', 's2']]
const bar2Result = Object.keys(fmpApdex).map(key => {
  const cur = fmpApdex[key][0];
  return [key, cur.fmp_apdex, cur.s1, cur.s2];
});
console.log(JSON.stringify([...temp2, ...bar2Result], null, 2));

[
  ["product", "fmp_apdex", "s1", "s2"],
  ["creditweb           ", "54.67", "28.61", "52.08"],
  ["applyweb            ", "70.81", "44.01", "86.77"],
  ["businessweb         ", "82.22", "64.93", "95.11"],
  ["cmscommon           ", "75.49", "52.90", "88.28"],
  ["creditwebmpaash5    ", "83.91", "68.96", "92.94"],
  ["applywebmpaash5     ", "98.56", "97.18", "99.78"],
  ["businesswebmpaash5  ", "87.29", "74.75", "98.51"],
  ["cmscommonmpaash5    ", "94.59", "89.68", "98.23"],
  ["tarowebh5           ", "59.13", "20.67", "83.92"],
  ["loanweb             ", "56.33", "15.08", "77.15"],
  ["huanbeiapp          ", "62.39", "27.75", "73.81"],
  ["cmscommonweb        ", "60.06", "23.25", "81.48"],
  ["miscweb             ", "51.31", "9.09", "51.93"],
  ["memberweb           ", "64.32", "31.46", "87.95"],
  ["hbzc                ", "63.27", "30.01", "80.54"],
  ["hbcampaign          ", "59.01", "19.36", "81.60"],
  ["apphq               ", "77.82", "62.51", "81.70"],
  ["hbmgm               ", "50.83", "6.99", "69.05"],
  ["cmsweb              ", "50.03", "2.36", "68.72"],
  ["hbcoupon            ", "71.76", "44.82", "91.46"],
  ["hbmembership        ", "66.13", "35.60", "76.21"]
]






option = {
  legend: {},
  tooltip: {},
  dataset: {
    source: [
  ["product", "fmp_apdex", "s1", "s2"],
  ["creditweb           ", "54.67", "28.61", "52.08"],
  ["applyweb            ", "70.81", "44.01", "86.77"],
  ["businessweb         ", "82.22", "64.93", "95.11"],
  ["cmscommon           ", "75.49", "52.90", "88.28"],
  ["creditwebmpaash5    ", "83.91", "68.96", "92.94"],
  ["applywebmpaash5     ", "98.56", "97.18", "99.78"],
  ["businesswebmpaash5  ", "87.29", "74.75", "98.51"],
  ["cmscommonmpaash5    ", "94.59", "89.68", "98.23"],
  ["tarowebh5           ", "59.13", "20.67", "83.92"],
  ["loanweb             ", "56.33", "15.08", "77.15"],
  ["huanbeiapp          ", "62.39", "27.75", "73.81"],
  ["cmscommonweb        ", "60.06", "23.25", "81.48"],
  ["miscweb             ", "51.31", "9.09", "51.93"],
  ["memberweb           ", "64.32", "31.46", "87.95"],
  ["hbzc                ", "63.27", "30.01", "80.54"],
  ["hbcampaign          ", "59.01", "19.36", "81.60"],
  ["apphq               ", "77.82", "62.51", "81.70"],
  ["hbmgm               ", "50.83", "6.99", "69.05"],
  ["cmsweb              ", "50.03", "2.36", "68.72"],
  ["hbcoupon            ", "71.76", "44.82", "91.46"],
  ["hbmembership        ", "66.13", "35.60", "76.21"]
]
  },
  xAxis: [
    { type: 'category', gridIndex: 0 },
    { type: 'category', gridIndex: 1 }
  ],
  yAxis: [{ gridIndex: 0 }, { gridIndex: 1 }],
  grid: [{ bottom: '55%' }, { top: '55%' }],
  series: [
    // These series are in the first grid.
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },

    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },

    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },

    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },
    { type: 'bar', seriesLayoutBy: 'row' },

    { type: 'bar', seriesLayoutBy: 'row' },
    // These series are in the second grid.
    { type: 'bar', xAxisIndex: 1, yAxisIndex: 1 },
    { type: 'bar', xAxisIndex: 1, yAxisIndex: 1 },
    { type: 'bar', xAxisIndex: 1, yAxisIndex: 1 }
  ]
};











const bar1Result = Object.keys(fmpApdex).map(key => {
  const cur = fmpApdex[key];
  return {
    name: key,
    type: 'bar',
    barGap: 0,
    label: labelOption,
    emphasis: {
      focus: 'series'
    },
    data: [cur.fmp_apdex, cur.s1, cur.s2]
  },
});


// 数据
const posList = [
  'left',
  'right',
  'top',
  'bottom',
  'inside',
  'insideTop',
  'insideLeft',
  'insideRight',
  'insideBottom',
  'insideTopLeft',
  'insideTopRight',
  'insideBottomLeft',
  'insideBottomRight'
];
app.configParameters = {
  rotate: {
    min: -90,
    max: 90
  },
  align: {
    options: {
      left: 'left',
      center: 'center',
      right: 'right'
    }
  },
  verticalAlign: {
    options: {
      top: 'top',
      middle: 'middle',
      bottom: 'bottom'
    }
  },
  position: {
    options: posList.reduce(function (map, pos) {
      map[pos] = pos;
      return map;
    }, {})
  },
  distance: {
    min: 0,
    max: 100
  }
};
app.config = {
  rotate: 90,
  align: 'left',
  verticalAlign: 'middle',
  position: 'insideBottom',
  distance: 15,
  onChange: function () {
    const labelOption = {
      rotate: app.config.rotate,
      align: app.config.align,
      verticalAlign: app.config.verticalAlign,
      position: app.config.position,
      distance: app.config.distance
    };
    myChart.setOption({
      series: [
        {
          label: labelOption
        },
        {
          label: labelOption
        },
        {
          label: labelOption
        },
        {
          label: labelOption
        }
      ]
    });
  }
};
const labelOption = {
  show: true,
  position: app.config.position,
  distance: app.config.distance,
  align: app.config.align,
  verticalAlign: app.config.verticalAlign,
  rotate: app.config.rotate,
  formatter: '{c}  {name|{a}}',
  fontSize: 16,
  rich: {
    name: {}
  }
};
option = {
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {
    data: ['Forest', 'Steppe', 'Desert', 'Wetland']
  },
  toolbox: {
    show: true,
    orient: 'vertical',
    left: 'right',
    top: 'center',
    feature: {
      mark: { show: true },
      dataView: { show: true, readOnly: false },
      magicType: { show: true, type: ['line', 'bar', 'stack'] },
      restore: { show: true },
      saveAsImage: { show: true }
    }
  },
  xAxis: [
    {
      type: 'category',
      axisTick: { show: false },
      data: ['2012', '2013', '2014', '2015', '2016']
    }
  ],
  yAxis: [
    {
      type: 'value'
    }
  ],
  series: [
    {
      name: 'Forest',
      type: 'bar',
      barGap: 0,
      label: labelOption,
      emphasis: {
        focus: 'series'
      },
      data: [320, 332, 301, 334, 390]
    },
    {
      name: 'Steppe',
      type: 'bar',
      label: labelOption,
      emphasis: {
        focus: 'series'
      },
      data: [220, 182, 191, 234, 290]
    },
    {
      name: 'Desert',
      type: 'bar',
      label: labelOption,
      emphasis: {
        focus: 'series'
      },
      data: [150, 232, 201, 154, 190]
    },
    {
      name: 'Wetland',
      type: 'bar',
      label: labelOption,
      emphasis: {
        focus: 'series'
      },
      data: [98, 77, 101, 99, 40]
    }
  ]
};

