gulp  = require('gulp');
peg   = require('gulp-peg');
gutil = require('gulp-util');

paths = {
	scripts : {
		peg : { src: "src/peg/*.pegjs", dest: "src/js/ast" },

		dest: "src/js"
	},
}

gulp.task ("compile:peg", function () {
	return gulp.src(paths.scripts.peg.src)
		.pipe( peg({ optimize : "speed" })
					.on("error", gutil.log))
		.pipe( gulp.dest(paths.scripts.dest))
});

gulp.task ("watch", function () {
	gulp.watch(paths.scripts.peg.src, ['compile:peg']);
})

gulp.task ('default', ['compile:peg']);