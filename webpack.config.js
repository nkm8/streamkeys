const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = (env, argv) => ({

  entry: {
    background: './code/js/background.js',
    contentscript: './code/js/contentscript.js',
    options: './code/js/options.js',
    popup: './code/js/popup/popup.js',
  },

  output: {
    path: path.resolve(__dirname, './build/'),
    filename: '[name].js'
  },

  module: {
    rules: [
      {
        test: /\.s[ac]ss$/i,
        use: [
          'style-loader',
          'css-loader',
          'sass-loader',
        ],
      },
    ],
  },

  plugins: [

    new CleanWebpackPlugin(),

    new HtmlWebpackPlugin({
      inject: false,
      chunks: ['options'],
      template: path.join(__dirname, "code", "html", "options.html"),
      filename: 'options.html',
    }),

    new HtmlWebpackPlugin({
      inject: false,
      chunks: ['popup'],
      template: path.join(__dirname, "code", "html", "popup.html"),
      filename: 'popup.html',
    }),

    new CopyWebpackPlugin([
      {
        from: "code/manifest.json",
        transform: function (content, path) {
          // generates the manifest file using the package.json informations
          return Buffer.from(JSON.stringify({
            version: process.env.npm_package_version,
            ...JSON.parse(content.toString())
          }))
        }
      },
      {context: 'code', from: '*.png'},
      {context: 'code', from: '*.ico'},
      {context: 'code', from: 'js/controllers/', to: 'js/controllers/'},
      {context: 'code', from: 'js/inject/', to: 'js/inject/'},
      {context: 'code', from: 'fonts/', to: 'fonts/'},
    ]),

  ],
});
