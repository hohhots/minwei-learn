'use strict';

import path from 'path';
import gulp from 'gulp';
import logger from 'gulp-logger';
import replace from 'gulp-replace';
import pump from 'pump';
import del from 'del';
import runSequence from 'run-sequence';
import browserSync from 'browser-sync';
import swPrecache from 'sw-precache';
import gulpLoadPlugins from 'gulp-load-plugins';
import { output as pagespeed } from 'psi';

import pkg from './package.json';
import paths from './gulp.config.json';

const $ = gulpLoadPlugins();
const reload = browserSync.reload;

// Concatenate all vendors minified js files
gulp.task('vendorJs', (cb) => {
    pump(
        [
            gulp.src(paths.vendorjs),
            $.newer('.tmp/content/vendor.min.js'),
            logger({
                before: 'Start concatenate and vendor js!',
            }),
            $.concat('vendor.min.js'),
            $.uglify(),
            // Output files
            gulp.dest('.tmp/content')
        ],
        cb
    );
});

// Concatenate and minify JavaScript. Optionally transpiles ES2015 code to ES5.
// to enable ES2015 support remove the line `"only": "gulpfile.babel.js",` in the
// `.babelrc` file.

gulp.task('appJs', ['vendorJs'], (cb) => {
    pump(
        [
            gulp.src(paths.appjs),
            $.newer('.tmp/content/app.min.js'),
            logger({
                before: 'Start concatenate and minify app js!',
            }),
            $.sourcemaps.init(),
            $.babel(),
            $.sourcemaps.write(),
            gulp.dest('.tmp/content'),
            $.concat('app.min.js'),
            $.uglify(),
            // Output files
            $.size({ title: 'scripts' }),
            $.sourcemaps.write('./'),
            gulp.dest('.tmp/content')
        ],
        cb
    );
});

gulp.task('scripts', ['appJs'], (cb) => {
    pump(
        [
            gulp.src(paths.allminjs),
            $.newer('.tmp/content/main.min.js'),
            logger({
                before: 'Start concatenate and minify js!',
            }),
            $.concat('main.min.js'),
            // Output files
            gulp.dest('.tmp/content'),
            $.uglify(),
            gulp.dest('dist/content')
        ],
        cb
    );
});

gulp.task('fonts', (cb) => {
    pump(
        [
            gulp.src(paths.fonts),
            $.newer('.tmp/content/fonts'),
            logger({
                before: 'Start move fonts!',
            }),
            gulp.dest('.tmp/content/fonts'),
            gulp.dest('dist/content/fonts'),
        ],
        cb
    );
});

gulp.task('vendorCss', (cb) => {
    pump(
        [
            gulp.src(paths.vendorcss),
            $.newer('.tmp/content/vendor.min.css'),
            logger({
                before: 'Start concatenate and minify vendor css!',
            }),
            $.if('font-awesome.min.css', replace('../', '')),
            $.concat('vendor.min.css'),
            gulp.dest('.tmp/content')
        ],
        cb
    );
});

// Compile and automatically prefix stylesheets
gulp.task('appCss', ['vendorCss'], (cb) => {
    const AUTOPREFIXER_BROWSERS = [
        'ie >= 10',
        'ie_mob >= 10',
        'ff >= 30',
        'chrome >= 34',
        'safari >= 7',
        'opera >= 23',
        'ios >= 7',
        'android >= 4.4',
        'bb >= 10'
    ];

    pump(
        [
            gulp.src(paths.appcss),
            $.newer('.tmp/content/app.min.css'),
            logger({
                before: 'Start concatenate and minify app css!',
            }),
            $.autoprefixer(AUTOPREFIXER_BROWSERS),
            $.sourcemaps.init(),
            $.sourcemaps.write(),
            gulp.dest('.tmp/content'),
            $.cssnano(),
            // Output files
            $.size({ title: 'styles' }),
            $.concat('app.min.css'),
            $.sourcemaps.write('./'),
            gulp.dest('.tmp/content')
        ],
        cb
    );
});

gulp.task('styles', ['appCss', 'fonts'], (cb) => {
    pump(
        [
            gulp.src(paths.allmincss),
            $.newer('.tmp/content/main.min.css'),
            logger({
                before: 'Start concatenate and minify css!',
            }),
            $.concat('main.min.css'),
            // Output files
            gulp.dest('.tmp/content'),
            $.if('*.css', $.cssnano()),
            gulp.dest('dist/content')
        ],
        cb
    );
});

gulp.task('serve', ['scripts', 'styles'], () => {
    browserSync({
        notify: false,
        // Customize the Browsersync console logging prefix
        logPrefix: 'WSK',
        // Allow scroll syncing across breakpoints
        scrollElementMapping: ['main', '.mdl-layout'],
        // Run as an https by uncommenting 'https: true'
        // Note: this uses an unsigned certificate which on first access
        //       will present a certificate warning in the browser.
        // https: true,
        server: ['./', '.tmp', 'src/client'],
        port: 3000
    });

    gulp.watch(['src/client/**/*.html'], reload);
    gulp.watch(['src/client/content/**/*.{scss,css}'], ['styles', reload]);
    gulp.watch(['src/client/app/**/*.js'], ['scripts', reload]);
    //gulp.watch(['app/images/**/*'], reload);
});