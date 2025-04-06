package fun.jiucai.bogers.service;

import com.zfoo.hotswap.util.HotSwapUtils;
import com.zfoo.protocol.collection.CollectionUtils;
import com.zfoo.protocol.util.FileUtils;
import com.zfoo.scheduler.anno.Scheduler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;

/**
 * @author godotg
 */
@Component
@Slf4j
public class HotService {

    @Scheduler(cron = "0/1 * * * * ?")
    public void cronHotswap() throws IOException {
        var path = "/hotswap";
        var files = FileUtils.getAllReadableFiles(new File(path));
        if (CollectionUtils.isEmpty(files)) {
            return;
        }

        log.info("开始热更新[{}]", files.size());
        for (var file : files) {
            if (!file.isFile()) {
                continue;
            }
            var bytes = FileUtils.readFileToByteArray(file);
            HotSwapUtils.hotswapClass(bytes);
            FileUtils.deleteFile(file);
        }
        log.info("热更新之后[{}]", files.size());
    }

}
