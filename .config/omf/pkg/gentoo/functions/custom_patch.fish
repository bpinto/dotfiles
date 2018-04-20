function custom_patch -a package
  if [ -z "$package" ]
    echo 'You need to specify a category/package-name.'
    return 1
  end

  if [ -z (echo $package | grep '/') ]
    echo 'You need to specify a category/package-name.'
    return 1
  end

  mkdir -p /etc/portage/patches/$package
  git patch | cat | \
    sed \
    -e '/^index /d' \
    -e '/^new file mode /d' \
    -e '/^Index:/d' \
    -e '/^=========/d' \
    -e '/^RCS file:/d' \
    -e '/^retrieving/d' \
    -e '/^diff/d' \
    -e '/^Files .* differ$/d' \
    -e '/^Only in /d' \
    -e '/^Common subdirectories/d' \
    -e '/^deleted file mode [0-9]*$/d' \
    -e '/^+++/s:\t.*::' \
    -e '/^---/s:\t.*::' | \
    tee "/etc/portage/patches/$package/local.patch"
end
