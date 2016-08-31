module.exports = {
  config: {
    fontSize: 15,
    fontFamily: '"Anonymous Pro For Powerline", Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',

    cursorColor: '#F81CE5',  // terminal cursor background color (hex)
    foregroundColor: '#fff', // color of the text
    backgroundColor: '#000', // terminal background color
    borderColor: '#333',     // border color (window, tabs)

    height: '500',
    width:  '500',

    hyperclean: {
      hideTabs: true
    },

    // custom css to embed in the main window
    css: '',

    // custom css to embed in the terminal window
    termCSS: `
      x-screen a {
        color: #ff2e88;
      }
    `,

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '12px 14px',

    // some color overrides. see http://bit.ly/29k1iU2 for
    // the full list
    colors: [
      '#000000',
      '#ff0000',
      '#33ff00',
      '#ffff00',
      '#0066ff',
      '#cc00ff',
      '#00ffff',
      '#d0d0d0',
      '#808080',
      '#ff0000',
      '#33ff00',
      '#ffff00',
      '#0066ff',
      '#cc00ff',
      '#00ffff',
      '#ffffff'
    ]
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
    'hyperclean',
    'hypercwd',
    'hyperlinks-iterm',
    'hyperterm-deep-space',
    'hyperterm-subpixel-antialiased',
  ],

  // in development, you can create a directory under
  // `~/.hyperterm_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: []
};
