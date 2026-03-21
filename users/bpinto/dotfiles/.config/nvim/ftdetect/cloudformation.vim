" From: https://github.com/speshak/vim-cfn

function! DetectCfn(type)
    let likely = 0
    let pointsRequired = 10

    " A mapping of all the important words in a CloudFormation template to the
    " number of points they're worth when detecting a file type. The values
    " were chosen fairly arbitrarily, but the section headers are worth 1
    " point, intrinsic functions are worth 2, and pseudo parameters are worth
    " 4. AWSTemplateFormatVersion is used as a sure sign its a Cfn template,
    " and AWS::\w+::\w+ is given 5 points since you're specifying resources
    " using the CloudFormation name.
    let pointMap = [
        \['AWSTemplateFormatVersion', 100],
        \['\vAWS::\w+::\w+', 5],
        \['AWS::AccountId', 4],
        \['AWS::NotificationARNs', 4],
        \['AWS::NoValue', 4],
        \['AWS::Partition', 4],
        \['AWS::Region', 4],
        \['AWS::StackId', 4],
        \['AWS::StackName', 4],
        \['AWS::URLSuffix', 4],
        \['Fn::Base64', 2],
        \['!Base64', 2],
        \['Fn::Cidr', 2],
        \['!Cidr', 2],
        \['Fn::FindInMap', 2],
        \['!FindInMap', 2],
        \['Fn::GetAZs', 2],
        \['!GetAZs', 2],
        \['Fn::ImportValue', 2],
        \['!ImportValue', 2],
        \['Fn::Join', 2],
        \['!Join', 2],
        \['Fn::Select', 2],
        \['!Select', 2],
        \['Fn::Split', 2],
        \['!Split', 2],
        \['Fn::Sub', 2],
        \['!Sub', 2],
        \['Fn::Transform', 2],
        \['!Transform', 2],
        \['!Ref', 2],
        \['Description', 1],
        \['Metadata', 1],
        \['Parameters', 1],
        \['Mappings', 1],
        \['Conditions', 1],
        \['Transform', 1],
        \['Resources', 1],
        \['Outputs', 1],
        \]
    for lineContents in getline(1, line('$'))
        for strPoints in pointMap
            if lineContents =~ strPoints[0]
                let likely += strPoints[1]
            endif
            if likely > pointsRequired
                if a:type =~ "yaml"
                    set filetype=yaml.cloudformation
                elseif a:type =~ "json"
                    set filetype=json.cloudformation
                endif
                return
            endif
        endfor
    endfor
endfunction

augroup filetypedetect
    au BufRead,BufNewFile *.yaml,*.yml call DetectCfn('yaml')
    au BufRead,BufNewFile *.json call DetectCfn('json')
    au BufNewFile,BufRead *.template setfiletype yaml.cloudformation
augroup END
