'use strict';

import path from 'path';
import gulp from 'gulp';
import del from 'del';
import runSequence from 'run-sequence';
import browserSync from 'browser-sync';
import swPrecache from 'sw-precache';
import gulpLoadPlugins from 'gulp-load-plugins';
import { output as pagespeed } from 'psi';
import pkg from './package.json';

const reload = browserSync.reload;

gulp.task('serve', [], () => {
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
        server: ['./','src/client'],
        port: 3000
    });

    gulp.watch(['src/client/**/*.html'], reload);
    gulp.watch(['/src/client/content/**/*.{scss,css}'], ['styles', reload]);
    // gulp.watch(['app/scripts/**/*.js'], ['lint', 'scripts', reload]);
    // gulp.watch(['app/images/**/*'], reload);
});