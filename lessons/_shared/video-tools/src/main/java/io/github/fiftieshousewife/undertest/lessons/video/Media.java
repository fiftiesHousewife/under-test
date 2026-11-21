package io.github.fiftieshousewife.undertest.lessons.video;

import java.nio.file.Path;
import java.util.List;

/** Where a lesson's video files live (lessons/<id>/media/<id>.*), and its scenes timed to the recorded video. */
record Media(Path root, String lesson) {

    Path folder() {
        return root.resolve("lessons").resolve(lesson).resolve("media");
    }

    Path file(final String suffix) {
        return folder().resolve(lesson + suffix);
    }

    String name(final String suffix) {
        return lesson + suffix;
    }

    String safeLesson() {
        return lesson.replace('\r', ' ').replace('\n', ' ');
    }

    /** Scenes from the script, stretched to the recorded silent video's real length when it exists. */
    List<Scene> scenes() {
        final List<Scene> planned = TapeTimeline.scenes(root, file(".tape"));
        final double plannedLength = planned.getLast().end();
        final double factor = ExternalCommand.videoSeconds(file(".silent.mp4")).orElse(plannedLength) / plannedLength;
        return planned.stream().map(s -> new Scene(s.title(), s.start() * factor, s.end() * factor)).toList();
    }
}
