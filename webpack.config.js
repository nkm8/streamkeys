const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const fs = require('fs');

module.exports = (env, argv) => {

  let mainConfig = {

    entry: {
      background: './code/js/background.js',
      contentscript: './code/js/contentscript.js',
      options: './code/js/options.js',
      popup: './code/js/popup/popup.js',
    },

    output: {
      path: path.join(process.cwd(), './build/'),
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

      new HtmlWebpackPlugin({
        inject: false,
        chunks: ['options'],
        template: './code/html/options.html',
        filename: 'options.html',
      }),

      new HtmlWebpackPlugin({
        inject: false,
        chunks: ['popup'],
        template: './code/html/popup.html',
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
        {context: 'code', from: 'fonts/', to: 'fonts/'},
      ]),

    ],
  };

  let controllerConfig = {
    entry: {},
    output: {
      path: path.join(process.cwd(), './build/js/controllers/'),
      filename: '[name].js'
    },
    resolve: {
      modules: ['./code/js/modules', 'node_modules']
    }
  };

  for(let controllerFileName of fs.readdirSync('./code/js/controllers/')) {
    controllerConfig.entry[path.basename(controllerFileName, '.js')] = `./code/js/controllers/${controllerFileName}`;
  }

  let injectConfig = {
    entry: {},
    output: {
      path: path.join(process.cwd(), './build/js/inject/'),
      filename: '[name].js'
    },
  };

  for(let injectFileName of fs.readdirSync('./code/js/inject/')) {
    injectConfig.entry[path.basename(injectFileName, '.js')] = `./code/js/inject/${injectFileName}`;
  }

  return [mainConfig, controllerConfig, injectConfig];
};
