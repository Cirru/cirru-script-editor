
fs = require('fs');
webpack = require('webpack')

module.exports = {
  entry: {
    main: [
      'webpack-dev-server/client?http://0.0.0.0:8080',
      'webpack/hot/dev-server',
      './src/main'
    ]
  },
  output: {
    path: 'build/',
    filename: '[name].js',
    publicPath: 'http://localhost:8080/build/'
  },
  resolve: {
    extensions: ['', '.js', '.cirru', '.css']
  },
  module: {
    loaders: [
      {test: /\.coffee$/, loaders: ['react-hot', 'coffee'], exclude: /node_modules/},
      {test: /\.cirru$/, loaders: ['react-hot', 'cirru-script'], exclude: /node_modules/},
      {test: /\.css$/, loaders: ['style', 'css']},
      {test: /\.png$/, loaders: ['url']}
    ]
  },
  plugins: [
    new webpack.NoErrorsPlugin(),
    function() {
      this.plugin('done', function(stats) {
        content = JSON.stringify(stats.toJson().assetsByChunkName, null, 2)
        return fs.writeFileSync('assets.json', content)
      })
    }
  ]
}
