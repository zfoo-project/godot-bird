package fun.jiucai.bogers.protocol.login;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KickPlayerNotice {

    private long sid;
    private long uid;

}
